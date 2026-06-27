class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/refs/tags/v1.9.22.tar.gz"
  sha256 "1e42b9fc4ad7db7befd414d45ab2f8a159c0b30fcd6eee452be662298766a849"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "fff5cd2469005f7ce17c430b5b0702ddae63ffc10fffeee4265eaa4eff14d586"
    sha256 arm64_sequoia: "db8845aed88dd26297e2b9e128b0a6325b57e83c977c82c9764dabab0f5eb5a2"
    sha256 arm64_sonoma:  "1d10444db8e31dea0532e9947398366dd3f9d2ecf94f937a4a4bd994abf48b11"
    sha256 sonoma:        "cfc72eb5ff3bd8e524f1120b06e3629b8562cf428bc0bab2e4fcb189a078a7de"
    sha256 arm64_linux:   "41d6192aa532805d5ba0ada750c27b40bfb431d1543005716181a0cefc40011e"
    sha256 x86_64_linux:  "638c07b7fd17581e2cb03676f5f86fa3957f1f100d9ea42eacb33c04b1336cd6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libsamplerate"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "aften"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  # Backport new waf to fix build on Python 3.12
  patch do
    url "https://github.com/jackaudio/jack2/commit/250420381b1a6974798939ad7104ab1a4b9a9994.patch?full_index=1"
    sha256 "919f94a5eb4a00854f90b6618a35be4ba9ab3d8cc56f09a1fba2277030363b20"
  end

  def install
    # Disabling metadata feature as it needs unmaintained Berkeley DB.
    # Can restore if upstream switches to an alternative, https://github.com/jackaudio/jack2/issues/557
    system "python3", "./waf", "configure", "--prefix=#{prefix}", "--db=no"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  service do
    run [opt_bin/"jackd", "-X", "coremidi", "-d", "coreaudio"]
    keep_alive true
    working_dir opt_prefix
    environment_variables PATH: "/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin"
  end

  test do
    args = ["-d", "dummy"]
    args += ["-X", "coremidi"] if OS.mac?
    spawn bin/"jackd", *args

    assert_match "jackdmp version #{version}", shell_output("#{bin}/jackd --version")
  end
end
