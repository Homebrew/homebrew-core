class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2022.04.01.tar.bz2"
  sha256 "1670b28865a8b82a57bb6dfea7f16e2fa4145d2f354910bb17380b32c9b94763"
  license "MIT"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f4aac768566d7d4f836ce686199b08585d4eec473e9d5f200901c2f7cfa1e434"
    sha256 cellar: :any,                 arm64_big_sur:  "0e70e3e20027f3ff0e0d1861b748652e8ab246f94b1fda4d9fd3c94cc5cad767"
    sha256 cellar: :any,                 monterey:       "64635847e06da3d6e266f1b40c96dee5426c105ed9b729bc89f6c140b8a1dd3f"
    sha256 cellar: :any,                 big_sur:        "35bc90ee98a331be04276847b798f182735edac577e08fe52eec3cc7b797290f"
    sha256 cellar: :any,                 catalina:       "bfd957e751c983b93c60bbd35f4bb559a4404984abb7868072d7e5a7053d9ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee38d829cc76f5e0af0d6622d5b3039d9223b2ed22ab33ee06589a4571f4fa5"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
