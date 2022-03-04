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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1f6db782d253c6b16439016839cfe511eeefa0560c29ed1ff2d6b20e0807340"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e0fea843f9b9176f9f5eeb492e2cd42bd1b3a68ca06847eb778251d78fd652"
    sha256 cellar: :any_skip_relocation, monterey:       "d192b665eb272fe7c07c5e30382badba3a4444b2ff67ba055ca8a8f79bb288fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f34c6236bfa40a19fac7ae22fed6569c6b66abb4c0c74425a6cbb0a73ab5b7b"
    sha256 cellar: :any_skip_relocation, catalina:       "f025e2cf293b38b62808cb372574a928633eec3f4e45e581198efbf9f84c3c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ab3a05b6f3bdcf90542d6e9a66c30c31a178b52bfc2a9bc17729bf61d1ea5e"
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
