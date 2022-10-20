class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.1.tar.gz"
  sha256 "1456dd9172903cd997e7ade6ba45b5937cfce023682a2ceb140201b608fbc628"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46fe532506472ef37d9235e418f6d50428d8c7fb4293160474b89ff7fa6d6d88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "522aefeee0231a275a277f53235617ed69b54df5dd1c6895e19c70a3d3e587aa"
    sha256 cellar: :any_skip_relocation, monterey:       "e9fa8f4230fdd1c85b79360d08cf1fd8e9dcf09a0ab896e12fd590959938fe01"
    sha256 cellar: :any_skip_relocation, big_sur:        "013e75f73cfce6dc23b3a2aae8ccc4a25cfa5bf5b4597099848f832fa430161e"
    sha256 cellar: :any_skip_relocation, catalina:       "cdf17a9aec1a081bb9dd25af7d52bd9b4ca86d10fcd75fe66c52e5f7a258efca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dcca0c2055a80b46dfddbc415411ddef07a36c47e734b7e3f8ab124ea98768d"
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
