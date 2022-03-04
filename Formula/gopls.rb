class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.8.0.tar.gz"
  sha256 "ea3bbf20965a414908fa060d1496036a6070e57cce92b1371cb2c692d896b286"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0f57645fa6fe9773b01e45fe1f132c4b3566d92ba463081ef1e0d9eecb5298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "144583c3339c1755e528cc9c09036db26e5055005818e5b07a854922468a6aec"
    sha256 cellar: :any_skip_relocation, monterey:       "15aa419374254bbeb91e6fc27682bec8dd2837e6e8c6b937c5971ee6482eb041"
    sha256 cellar: :any_skip_relocation, big_sur:        "6809ae82e92ec910b00dd069f809ca32cb4c49727610a18bb1bcba6f626ff1ba"
    sha256 cellar: :any_skip_relocation, catalina:       "36c8e1e97d6614a8771616fb10ef3165138e2fd7f511b1651547272dd2303370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d78a6e0a2a00464464e99e527df19c8823e891aaa6618d9a43d4ce6a5555c16"
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
