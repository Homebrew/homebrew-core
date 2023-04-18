class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/v1.9.22.tar.gz"
  sha256 "1e42b9fc4ad7db7befd414d45ab2f8a159c0b30fcd6eee452be662298766a849"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "de407106387c805a6117edb7e10646accf5cc25abed05b310475709b07d403c3"
    sha256 arm64_monterey: "44c6dfc147a7e6f5677e6f5a94ce46fe4ec87db6953c2893eb5bdc6082623eca"
    sha256 arm64_big_sur:  "5b71efa702af44215537e74f2f792a7f9a02253a10350a91a0043735de24d6ac"
    sha256 ventura:        "2f54c142f838c5ce1f248d44b5efb32cf52092c8e232b2848965c68a2c5a6066"
    sha256 monterey:       "59251197992e250453273d7cf62da7a4b11b730382686e3e5bb8349c9d7c8ce5"
    sha256 big_sur:        "df787dac8716e347bd2e336ac604042333e2ccff75cbe665412fb39fbb0f9cfc"
    sha256 x86_64_linux:   "7e201f19d5920e21582995edffb59667edefa7ac50ee3016cbd4fc4d872b548e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "berkeley-db"
  depends_on "libsamplerate"

  on_macos do
    depends_on "aften"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  def install
    if OS.mac? && MacOS.version <= :high_sierra
      # See https://github.com/jackaudio/jack2/issues/640#issuecomment-723022578
      ENV.append "LDFLAGS", "-Wl,-compatibility_version,1"
      ENV.append "LDFLAGS", "-Wl,-current_version,#{version}"
    end

    python3 = "python3.11"
    system python3, "./waf", "configure", "--prefix=#{prefix}"
    system python3, "./waf", "build"
    system python3, "./waf", "install"
  end

  service do
    run [opt_bin/"jackd", "-X", "coremidi", "-d", "coreaudio"]
    keep_alive true
    working_dir opt_prefix
    environment_variables PATH: "/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin"
  end

  test do
    fork do
      if OS.mac?
        exec "#{bin}/jackd", "-X", "coremidi", "-d", "dummy"
      else
        exec "#{bin}/jackd", "-d", "dummy"
      end
    end

    assert_match "jackdmp version #{version}", shell_output("#{bin}/jackd --version")
  end
end
