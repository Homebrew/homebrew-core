class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-4.2.1.tar.xz"
  sha256 "d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"

  bottle do
    sha256 "506f2f173b24afbf3467a5408a4268bbb749b0eccfa354a8c3a2c3139fd1deed" => :high_sierra
    sha256 "ec83ac264e9a13b6e83bd70e5f0d965e78ba46837244b224d0fae90f7e66631c" => :sierra
    sha256 "5c463865ee87a53bd13b380552a4dcfc4933fe100e2c740586ba69d1eb870c2e" => :el_capitan
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
