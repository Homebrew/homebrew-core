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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "70eae572ab2834459171f64ab8e715aa90496a16b58dd312affe30ed26d0380d"
    sha256 arm64_sequoia:  "e3cd7f8ab3b70baa1766b3a131b16ffe7a62a398f20a3ce7b6d6935c222b5925"
    sha256 arm64_sonoma:   "39affd1f135d3745a22bf4907e46509cdb4b1b3a8e654e23179e1a1ad92193bc"
    sha256 arm64_ventura:  "6210ae0eeab831aa965d6d737f22b7476224d1cd1daa1105cee116dd37a3627a"
    sha256 arm64_monterey: "e9ff1f4cef83787cd63bb788cd2c1818b64798d85c7081ed3b2ba42a8f40b149"
    sha256 sonoma:         "15b133b0d5b27e9a1e054fec07cd8c0c3e4972ace51ca2d6ec9b57b8ee4c5c85"
    sha256 ventura:        "6d6e8934386e7609ad4ab4af7ba321ffc0bf8673f93b2d2deca7fb3bc3207688"
    sha256 monterey:       "5079ca572c21ee6acc9574a0db44938e2c6099242d38a3cbd39bc4e4bc643c08"
    sha256 arm64_linux:    "13cdb9547db6f443c750059b2f230085bac7465964ff22d88aeb4b2eb5e08873"
    sha256 x86_64_linux:   "1632a4f4ebdf3e82dd5186dd71dd498a83bf47f4ef610b319d22bb201727e463"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL-3.0 restrictions
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
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
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
