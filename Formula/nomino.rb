class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.2.2.tar.gz"
  sha256 "d9c925a09e509c20f10aba6b8130412f6f6cf91cfa398933e432da2a6626b83e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be009a3126715ce645e0c5a983b7018a6d02ec613ceb6279bdc669556d314735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1fff5952fb89aa4a7c5bc9ae2d146db39e7d004e9411d6b66b4526b9e2517a7"
    sha256 cellar: :any_skip_relocation, monterey:       "1c888714aaa85fa5dd03ab92dd72cf0f175a20ec751716ca8b744b14cbdcadb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c1c1411e56531ca01858d7c397bee3b960d0f13ea6a237491025679e33f4de"
    sha256 cellar: :any_skip_relocation, catalina:       "7260f98ba725e23a743ba6cf6a5ca2a873b1e3c9b248112fc36e5b07eeecd975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03106420aa812dc997c6d3733490385ef3366cf6575b845ca5b67f8c4b097d41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end
