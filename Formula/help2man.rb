class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.11.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.11.tar.xz"
  sha256 "5985b257f86304c8791842c0c807a37541d0d6807ee973000cf8a3fe6ad47b88"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe3ddffa91085d678ab198ffe981edf55b6347faf55bcc04f93fc4eb457d036e" => :mojave
    sha256 "fe3ddffa91085d678ab198ffe981edf55b6347faf55bcc04f93fc4eb457d036e" => :high_sierra
    sha256 "c69b38804b45c6aafd0afc2ee9bda2eb530e5c0e1bff9e5bb3709cba4d7d58b7" => :sierra
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
