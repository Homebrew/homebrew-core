class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "f5545e9aca8c79042080e8510ec77ac66ed3ac4acf976a8bbeb53e04fae02630"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "630c61c244ea8d1fd2e3cd9ecb43c1be93e7a0b77fcf82fb959e2f60a842d6b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18c933f3221b45e4f16e509ede9762c0729708a244f6df0fa04e208969347146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "153997b3e3d19cb901e55fd38c69b8c47897ee3378e8886eb62bf1e23bd11ce4"
    sha256 cellar: :any_skip_relocation, sonoma:         "39f1a3b6f73afcf587852bc0ae8628ab4fcd53281db78350366f126ee6175ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "8b13d76725689c23108cbc37461491dc34f4ddcc506b921cf71708efd201f4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "ef75fc7b7e2b75f3e9798f29c7fd6a072981ceacba40a27f56b9a88b4f953c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e2aa0e11ec012f5e1c2f9184a3b77d763edc7998a8bec229f0c764e4e975ba"
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
