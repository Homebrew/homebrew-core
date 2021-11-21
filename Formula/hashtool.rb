class Hashtool < Formula
  desc "Hash strings from the command line"
  homepage "https://firelite4.github.io/HashTool/"
  url "https://github.com/FireLite4/HashTool/releases/download/v1.0.0/hashtool.tar.gz"
  version "1.0"
  sha256 "257865c04bc32329338738c6d65962b628d5d5fa7828cd42747bad61f2f06aaa"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "257865c04bc32329338738c6d65962b628d5d5fa7828cd42747bad61f2f06aaa"
  end

  depends_on "python@3.10"

  def install
    bin.install "hashtool.py" => "hashtool"
  end

  test do
    system "#{bin}/hashtool", "-s hello"
  end
end
