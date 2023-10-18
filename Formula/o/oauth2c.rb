class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "804b5f504e10d9b4c8fc21d9c936863a934847c8b6aa787cde10b0a264e23a26"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e848df74bce92ddfc47a6ad2c97160aab48604f4b2485224e0c40f0d46b25e5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff33d459fa2ee615797f69e428ba82258ac62250eb6091924ebdd89831d190d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e72016325cbc73330e834c163065babc4265c033bc0b497ea02928e4170fdf89"
    sha256 cellar: :any_skip_relocation, sonoma:         "178e111cbae23778dfab81676743a8a63a506239e21961915b2eb85724c530c6"
    sha256 cellar: :any_skip_relocation, ventura:        "de9f0406af1349f75c97813af537b9f5a7026295fd393ba3c84b47faad75a071"
    sha256 cellar: :any_skip_relocation, monterey:       "dcfee635232be30463605f15e3380e76842725ffed941572a43d5e118ad26995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c3fcc4480b823606272331cfefbc3825bc807ddfe2c2f1eca035da9ede6f4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "\"access_token\":",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end
