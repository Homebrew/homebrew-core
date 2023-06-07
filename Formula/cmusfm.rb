class Cmusfm < Formula
  desc "Last.fm standalone scrobbler for the cmus music player"
  homepage "https://github.com/Arkq/cmusfm"
  url "https://github.com/Arkq/cmusfm/archive/v0.4.1.tar.gz"
  sha256 "ff5338d4b473a3e295f3ae4273fb097c0f79c42e3d803eefdf372b51dba606f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91b73a874c10d4deeebcee02a451edff2e1034f88da878506f221eb6a7fa4037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6aa58d8aaaf982d09847ca12fa1d90a29d9697d3c396445345d6151f7268ab3e"
    sha256 cellar: :any_skip_relocation, ventura:       "38859b2343c65800586364cf047ec4ffe4325c9171d8f8082a587fc9c9db2643"
    sha256 cellar: :any_skip_relocation, monterey:      "f4693ccd831c18591443a07ca6e92d066d912dc2deb91be1e58d9b926d556e13"
    sha256 cellar: :any_skip_relocation, big_sur:       "fb3118b55ecf198907e43466587b28d328d2f41337f75701c4288ea72759ee7b"
    sha256 cellar: :any_skip_relocation, catalina:      "c5f5828389cb7aad8fbc5ffb15dcd522f3e9f70718de08bbc5425f7c33118d56"
    sha256 cellar: :any_skip_relocation, mojave:        "00e046ccd67253bfc0f9031fc7746ef03e4a66d0e1df2fa5aabc64e537863048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363af3cb7ebfdf77f78b34239c4192810dafbf60de75a675296ecd5f797ceb7f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libfaketime" => :test

  uses_from_macos "curl"

  def install
    system "autoreconf", "--install"
    mkdir "build" do
      system "../configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--disable-silent-rules"
      system "make", "install"
    end
  end

  test do
    cmus_home = testpath/".config/cmus"
    cmusfm_conf = cmus_home/"cmusfm.conf"
    cmusfm_sock = cmus_home/"cmusfm.socket"
    cmusfm_cache = cmus_home/"cmusfm.cache"
    faketime_conf = testpath/".faketimerc"

    test_artist = "Test Artist"
    test_title = "Test Title"
    test_duration = 260
    status_args = %W[
      artist #{test_artist}
      title #{test_title}
      duration #{test_duration}
    ]

    mkpath cmus_home
    touch cmusfm_conf

    begin
      server = fork do
        faketime_conf.write "+0"
        if OS.mac?
          ENV["DYLD_INSERT_LIBRARIES"] = Formula["libfaketime"].lib/"faketime"/"libfaketime.1.dylib"
          ENV["DYLD_FORCE_FLAT_NAMESPACE"] = "1"
        else
          ENV["LD_PRELOAD"] = Formula["libfaketime"].lib/"faketime"/"libfaketime.so.1"
        end
        ENV["FAKETIME_NO_CACHE"] = "1"
        exec bin/"cmusfm", "server"
      end
      loop do
        sleep 0.5
        assert_equal nil, Process.wait(server, Process::WNOHANG)
        break if cmusfm_sock.exist?
      end

      system bin/"cmusfm", "status", "playing", *status_args
      sleep 5
      faketime_conf.atomic_write "+#{test_duration}"
      system bin/"cmusfm", "status", "stopped", *status_args
    ensure
      Process.kill :TERM, server
      Process.wait server
    end

    assert_predicate cmusfm_cache, :exist?
    strings = shell_output "strings #{cmusfm_cache}"
    assert_match(/^#{test_artist}$/, strings)
    assert_match(/^#{test_title}$/, strings)
  end
end
