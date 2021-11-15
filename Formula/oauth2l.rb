class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.2.2.tar.gz"
  sha256 "6bee262a59669be86e578190f4a7ce6f7b18d5082bd647de82c4a11257a91e83"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "881f2ba9c36fcabcaacd881e99265b41622f8aaa437ea769eaeba1a6d187bf99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97afa02857ded76e58750c9258dcdf6696cd341f4ef5da3fcef1b506d4af5d60"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2f5238d702f84f01aa24b845227d5ef7fb3edc4a60099ce9a7cde92b46ca3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3997e4c2392de8d3ee2e7b4e6e6bdcdf6236e9d75fe1007afdf9b4aa4228913"
    sha256 cellar: :any_skip_relocation, catalina:       "a1364fb71118addb9dfd3ad4c30a4ffcc337eb5115c7ae40a7fe6825492116c3"
    sha256 cellar: :any_skip_relocation, mojave:         "5dfc5cfee1683e24ff6740c823920f629b13d834de40dc7832819e37428f9b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "885ca033df96d0bc0e24402fd9cba8cba1ffee1b52498c41ff91b1a2c2be2b3d"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
