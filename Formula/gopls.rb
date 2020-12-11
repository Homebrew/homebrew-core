class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.0-pre.1.tar.gz"
  sha256 "e128d9c3293026a347790812737703a7ae3abeaef772aa89943a28e9485102ff"
  license "BSD-3-Clause"

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
