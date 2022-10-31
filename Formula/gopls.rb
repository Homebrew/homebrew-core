class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.10.0.tar.gz"
  sha256 "e75b587e204f68e96324b34349ecb2dddf26d1789f90a029481c00473843f998"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8f22b3d4ea5cc8c31c7e9e3b53fdb5e73eba9ada33b4d1caedd5453010d86ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8e650bf4d91879f9492bc189e6c946b7d67bf1b137e522faa71a9c2921b69b4"
    sha256 cellar: :any_skip_relocation, monterey:       "adf3da779a68bedd5764fcaf4aaa753aa0ba5286cdd2742125e433a19a559850"
    sha256 cellar: :any_skip_relocation, big_sur:        "01bc2e431bfda50fe028ecf719bf380a670cc187e7ea492dd6122a8b34d21edd"
    sha256 cellar: :any_skip_relocation, catalina:       "d294acb3613f0225887e497de746b335792219fa84d9b8713ae218395fb71ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4a774c1b4d03f9a3a43ce4b6f074aff086c49c1d8a2b3081b399b9ab0ebffc"
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
