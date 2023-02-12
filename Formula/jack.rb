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
    sha256 arm64_ventura:  "9cf54ddb51aba0829825dcec602d85e18b232eac4c8557efe7a7e5bdcca05608"
    sha256 arm64_monterey: "5b8c6629a97e463b96bb2672c3a0cfb8da8b5cf91d147f632c7f6d351a7fe3cb"
    sha256 arm64_big_sur:  "a9732675aef73bf6a133a8130b46a81a275aad83abfc0d0d72b91f34580d11fb"
    sha256 ventura:        "4153adcbb219bfafaaf25aed11df7268222e255201f75b1ae16b1a59e6b54da7"
    sha256 monterey:       "8047fbdd9eefa085dd3e66584d907bbbcfee2e7651f80836ff621844d39a53aa"
    sha256 big_sur:        "f1f19dbf7ba59e389e51d325997b6c4173ebcf3c076732edd1d3ebbf51af5ab0"
    sha256 catalina:       "d4ac8617761bb59dfaa1390d237ef7ad2b2733283353a8484fd4a1c8a82b4f79"
    sha256 x86_64_linux:   "8a52eb2b5ec3ad62d4b573e7dd5997142d7435600da01cae8156dd6f6b0dae9b"
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
