class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.9.tar.gz"
  sha256 "b1cb4108d1d35c8e2d2630cdb78a42e1e10ff36ea00ce2e76577e1723905d4a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d92364f569f400fe378abc06e462c0986de710e3aa000f3422f399244250afc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ddb0ff605c5602edee7a88c6d743838ee0476cf457c4e094a7b590ae5cd2b57"
    sha256 cellar: :any_skip_relocation, monterey:       "cdedcb8dd1c50a6fd521823017c9dd15bb56f3ddcdcd61ed2c258e9d80848bc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe0aabf4acc22002b1fd6006c4710237673b477e377cdfadaaf115bb58414a2e"
    sha256 cellar: :any_skip_relocation, catalina:       "27356c38ecd5bc766abe0161dd44a8879187f8eb84e9e65ddf281bc5fd8380f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2089482594c2e4e341bd5846c1ce65920bcfd73d6a62f3298fc937295b4c11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
