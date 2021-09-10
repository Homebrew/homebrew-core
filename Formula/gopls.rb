class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.7.2.tar.gz"
  sha256 "7c4d5fab07890106b337cd292485bccc0fcf82da7ce246ac3fc55914aaf9d140"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3da9c6aedca9fd37c9022c8a7545a00e4d63ff33a9aaf6806bbd30ba4fc4724"
    sha256 cellar: :any_skip_relocation, big_sur:       "7217383324ca5d77ade1972e8357377bc2526913f7b2da3fd5a7021b649bb799"
    sha256 cellar: :any_skip_relocation, catalina:      "9d61076699f6cdf086bcc8104fc355f87158799261739956d85960994c6b028d"
    sha256 cellar: :any_skip_relocation, mojave:        "1e771496411197bac6386a0e6977e2cdbb6d5655a62e5e7126a0c3e6bd1b6496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf8e757e34afba03062e8d719576ec14fb5f4a0a19fbcd868babb130d429656"
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
