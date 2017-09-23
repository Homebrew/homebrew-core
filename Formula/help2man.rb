class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.5.tar.xz"
  sha256 "7ca60b2519fdbe97f463fe2df66a6188d18b514bfd44127d985f0234ee2461b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4bc801b9f67088dae36676eb358322ae25a4b5b863fe35f591c4b6c010cf86f" => :high_sierra
    sha256 "5d0de8d587ec57028dc662890894a3376cd07a1e83f5fa0c0e521bf9dde551ae" => :sierra
    sha256 "5d0de8d587ec57028dc662890894a3376cd07a1e83f5fa0c0e521bf9dde551ae" => :el_capitan
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man #{bin}/help2man")
  end
end
