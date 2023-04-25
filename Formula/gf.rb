class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "ebff69bb1edfb8828fbe2ebcf10314c2571faee88923ab687e46e78127cf8c6e"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c6533889ac03111b3f8a0c34612f07762bca17e9af5b1e9a40875f6ee8f199a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2072b80438b007e47b5c6f79796e435d69b7aed134c76b3480f2dadd6ccac0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a75db4143216346daa9ee9a2434671b054cd64a9babd0820414ad40889df773"
    sha256 cellar: :any_skip_relocation, ventura:        "8efc9abc316f204d4bfbafc37801b81226f38d37c2ee30f3be2fc483b815b0b8"
    sha256 cellar: :any_skip_relocation, monterey:       "62da0926bd045dd9d986618ce4924b50625e67004055c935ea0b046aba5f6a12"
    sha256 cellar: :any_skip_relocation, big_sur:        "94069132c7fdae7c6b4358fab779c5a1fda146aeee7cb72e0ae18cee56ff6837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d0dc8542472f92b618129d50ea5d07b63ce01ad35291dbcca7dc95e65ee235"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
