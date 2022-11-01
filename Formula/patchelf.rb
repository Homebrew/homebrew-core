class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.16.1/patchelf-0.16.1.tar.bz2"
  sha256 "ab915f3f4ccc463d96ce1e72685b163110f945c22aee5bc62118d57adff0ab7d"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be6e696075f760a78959e6b4aaf6c68a014976817379ebf7a63715aa50299429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "535c8105a1f612edb3883031115feaf09bf05250406d6ec139fefcf0110b2080"
    sha256 cellar: :any_skip_relocation, monterey:       "baa5072f1893b33b74f6527e049b9b4e62c97e8060874be1400dfd93247a58f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "20465844fe88f109eec14d1ad13fbfd6e6ab766f3d136f4bdf771e9185e08050"
    sha256 cellar: :any_skip_relocation, catalina:       "e947588049304ae23f5fc66bdcd6fa3194dccce8cb70bfb5a8a2f4e165432c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa7190cddb5b9c797a16df600ea2a072eaac7fddca699061ecfbfe9b7a4de071"
  end

  head do
    url "https://github.com/NixOS/patchelf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  fails_with gcc: "5" # Needs std::optional

  resource "homebrew-helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    if OS.linux?
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("homebrew-helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
