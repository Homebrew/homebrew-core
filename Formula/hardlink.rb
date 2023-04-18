class Hardlink < Formula
  desc "Replace file copies using hardlinks"
  homepage "https://jak-linux.org/projects/hardlink/"
  url "https://jak-linux.org/projects/hardlink/hardlink_0.3.0.tar.xz"
  sha256 "e8c93dfcb24aeb44a75281ed73757cb862cc63b225d565db1c270af9dbb7300f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "88e89ffc8475533034d4b4374d9554702c77397a8e252e8e3746a5f5bc6f66b0"
    sha256 cellar: :any,                 arm64_big_sur:  "fe5acfbc7a123db425beb0257ca23f4286b3260bd76b81027ee7528cc05bfdfd"
    sha256 cellar: :any,                 monterey:       "3d173e277d659f561dae36da590d56edf53aa759cee210cbaaa8fcaa0f6dea6a"
    sha256 cellar: :any,                 big_sur:        "1c2d9bd0578affd02e5b3ea25f09167665f555b652254cea27aabf1b704bf294"
    sha256 cellar: :any,                 catalina:       "f0b2171598c5eb9111c2923649f46e32a182af7bc5e5f6012f4f13178651e3ed"
    sha256 cellar: :any,                 mojave:         "971dab4459ef06afd11cf2cf7c0ade1ee7bcf959e359938f83b2b8a7d86a7d17"
    sha256 cellar: :any,                 high_sierra:    "4738a658357798d756d8a96f96d3700f387ae89d1db769b81675634e85018c19"
    sha256 cellar: :any,                 sierra:         "56ac75c51db6d7e19efe41eef24aa6646cdc126a113f5aacadd5f80043efc0d5"
    sha256 cellar: :any,                 el_capitan:     "d8b6e2d26d8f49a207c5082a97f1e5c31b35041bcfbc17a217a1c2ad4ff68551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b849b6cdc2d96380221c9dddc48a4c6485db0f4257ea7c48ade59b50e29f7bfd"
  end

  disable! date: "2022-09-14", because: "has been merged into `util-linux`"

  depends_on "pkg-config" => :build
  depends_on "gnu-getopt"
  depends_on "pcre"

  on_linux do
    keg_only "it conflicts with the maintained `hardlink` binary in `util-linux`"
  end

  def install
    # xattr syscalls are provided by glibc
    inreplace "hardlink.c", "#include <attr/xattr.h>", "#include <sys/xattr.h>"

    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "BINDIR=#{bin}", "install"
  end

  test do
    (testpath/"foo").write "hello\n"
    (testpath/"bar").write "hello\n"
    system bin/"hardlink", "--ignore-time", testpath
    (testpath/"foo").append_lines "world"
    assert_equal <<~EOS, (testpath/"bar").read
      hello
      world
    EOS
  end
end
