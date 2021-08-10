class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.7.1.tar.gz"
  sha256 "b4856f49ca402b91e3242bafd8c9e8b2ff670e4671bea810bb054e43b05f0f54"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f098f193550d93dcc51b749817d795ac7a975e6ad2a0e77facd4775ca094ebc"
    sha256 cellar: :any_skip_relocation, big_sur:       "5cddc70f97d373fe1acb02cf6c4cd36ed4d2b930a08b40e2aa8f18064b4b1f2e"
    sha256 cellar: :any_skip_relocation, catalina:      "ff9f6202131fe9d37d7f793d002070efc70d16c03b8b02d69447fbffde3f65a9"
    sha256 cellar: :any_skip_relocation, mojave:        "d59ab64d08581df96a1f786a3088a6409ce777925d2ce8ed5e497d4f25e2ecd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0f29cb41bef1dcfeb51c2402895929b4b267b8cca7163f2f094c04f0bf73c2"
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
