class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.5.5.tar.gz"
  sha256 "08d477a7c35021ec5d8950e25e1fcac86d7ec0ce8a421c20d932029e00efb1d8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8eae69564bfa8cfed1029f7a34b5f7133ce2842271cae300b5e291eaca1c83b6" => :big_sur
    sha256 "4fc207319168895d23299c5c461134391479d70781b6ed7f148526f8dc430bb0" => :catalina
    sha256 "f1ee8e73a322e36be90cabe8fa6558c641733baf0148c4b27163fb6afea07a02" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.generate", output["Commands"][0]["Command"]
    assert_equal "false", output["Options"]["Debugging"][0]["Default"]
  end
end
