class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.8.3.tar.gz"
  sha256 "a3128372f8bbd84b254a1e1ff6e417feba0d4b5ae01dfb640556331d7bed025e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87ea6f38e3b54c0153f3023e93643cf871102555eda5ed52d9bdf90e974b439"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ffe5693813646c1ebca99f26c8f47b1fbe7222cbe5a2a4a2f745deaac251fb5"
    sha256 cellar: :any_skip_relocation, monterey:       "8cea3cfa7e0b058ca600c4c7683b949e61b9d4af16af82674fe69bfabf9691f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "10e51a5a247f5017f1a984c798d7dae975807d701543ce9fa571c36e5758a837"
    sha256 cellar: :any_skip_relocation, catalina:       "95ffa25fb852ca5b11f9e76f8ad48154490924e0517a165127534aca13ddf13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58d2d428715bf7f991c490902d77158dafbdbe6735edfea7b652b928cdd66f7"
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

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
