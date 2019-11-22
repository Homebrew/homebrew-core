class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.11.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.11.tar.xz"
  sha256 "5985b257f86304c8791842c0c807a37541d0d6807ee973000cf8a3fe6ad47b88"

  bottle do
    cellar :any_skip_relocation
    sha256 "de8418f205b74a0194d44f061cbdecaceb9353ee8991651c75380d8d2394077f" => :catalina
    sha256 "0aecf41b06ca3914f21e370060652a4209560c13acde2b1bb9ffd03b1990f54a" => :mojave
    sha256 "0aecf41b06ca3914f21e370060652a4209560c13acde2b1bb9ffd03b1990f54a" => :high_sierra
    sha256 "3b0ce6bc3ddc6fcc6290132fac3da4c083a24dcaffad4323db1e4e8d99d6062d" => :sierra
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
