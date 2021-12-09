class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.14.3/patchelf-0.14.3.tar.bz2"
  sha256 "a017ec3d2152a19fd969c0d87b3f8b43e32a66e4ffabdc8767a56062b9aec270"
  license "GPL-3.0-or-later"
  head "https://github.com/NixOS/patchelf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86440e9f58c2b2451844fdc7a30bcc18f3ddc0e01adca2c1dcff6aea4475d2c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d21bf1cb91b7457afcaf0c3f85da7858b3dd862542e4e19bac5235b7a3b40ef"
    sha256 cellar: :any_skip_relocation, monterey:       "1e070e3bbfa9942aebdc0bd7d7b0cde5ebf96677f490a5a9c28f41463092d017"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfe10a967964115789954ec3866be9cfb3ea273cf7f025a3f8afda71d3e4b0f1"
    sha256 cellar: :any_skip_relocation, catalina:       "d5b64e5588d18dbae9ffc01c0ea07c45db379cd1c592b3affce58284cdf234cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298d89f90bd63ad3170f4f767fa304c3e2b7d722a4eec71242d0e7f7bc8ed22c"
  end

  on_linux do
    depends_on "gcc"
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
