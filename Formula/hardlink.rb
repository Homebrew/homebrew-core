class Hardlink < Formula
  desc "Replace file copies using hardlinks"
  homepage "https://jak-linux.org/projects/hardlink/"
  url "https://jak-linux.org/projects/hardlink/hardlink_0.3.0.tar.xz"
  sha256 "e8c93dfcb24aeb44a75281ed73757cb862cc63b225d565db1c270af9dbb7300f"

  bottle do
    cellar :any
    sha256 "971dab4459ef06afd11cf2cf7c0ade1ee7bcf959e359938f83b2b8a7d86a7d17" => :mojave
    sha256 "4738a658357798d756d8a96f96d3700f387ae89d1db769b81675634e85018c19" => :high_sierra
    sha256 "56ac75c51db6d7e19efe41eef24aa6646cdc126a113f5aacadd5f80043efc0d5" => :sierra
    sha256 "d8b6e2d26d8f49a207c5082a97f1e5c31b35041bcfbc17a217a1c2ad4ff68551" => :el_capitan
    sha256 "36c30ed90a3d2b9d2d4d07cb182c2838dfba276a05c22d022a42e16043e86f02" => :yosemite
    sha256 "cba1b82474c668bbb36e2e56cf7b36685924592d291dc05067d7c4a605686084" => :mavericks
    sha256 "733b12fdaffb5b2dd0f5d87394eaf058ce4a621d3234dca2b18a9487c1d487f2" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-getopt"
  depends_on "pcre"

  def install
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "BINDIR=#{bin}", "install"
  end

  test do
    system "#{bin}/hardlink", "--help"
  end
end
