class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/7.2.0.tar.gz"
  sha256 "cbc765637c685392adab117dbcd94a4932cd6488e7adf8058e893077179f80e7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abd27d6861fda7934cb8dfa4f354c0c68746fecd883c29a71079d29395d3c042"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a828ec20caa3a35374e5fb2c878eae00718af1294afbc617c8d7b686a2bb856a"
    sha256 cellar: :any_skip_relocation, monterey:       "7a7263c5df0bdfdf23e2aeb17961927b3aa3c83ed846e5c69e0b829eb0559d6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "df38e843f2a2f392c0bf45f1a33011e8f4c0eebcb07bd2b6b21c09d9d50a4a8d"
    sha256 cellar: :any_skip_relocation, catalina:       "518c267bfd640b7c159a098e05d3918f3bbbc07446c26a6841343f86a2572488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d853fe5bec8ae79d6f619860bb2fb5bb3064248f480e2cab81ee0e5b60ec5d5a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
