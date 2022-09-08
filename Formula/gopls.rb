class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.9.5.tar.gz"
  sha256 "c7b3a09f3820a0b3183ab5a08845f8d328565076d2834bb3b049a12eff6191e5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2db6ebf10390c5862a3307c5fbb2f772bb867037b4b279e4629059856ec5f16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ace18097750fb85bacf25eb2f0119ec8ccb5fdced6bdd132943a1790ba2fc7da"
    sha256 cellar: :any_skip_relocation, monterey:       "71215968d313218e3a647d312ec9a87b42bf6bd8b8c710fba3611c7c56ebb693"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b63d1251710990dae5ea0630a58c4ce81bb05461c96b71fd66258b83603367"
    sha256 cellar: :any_skip_relocation, catalina:       "b33750b8e8dfd78c87575bc1b8433c7cca0b34f849192aa2578cf473b847c204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf675da1f96e338d9d73ce206cb08fa2edf8e2f5106e4bc1add9ad9b448c54ca"
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
