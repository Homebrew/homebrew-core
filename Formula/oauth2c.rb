class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "85f7433644bf840ee115310362208f161834968a4455bdfa43dc77b9bbda8880"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f6643bbe732e785c9cbf5222f18bd4a8161ad35ab7f0ec4be4bc7044da98a2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c895ca19baff3f97aeecbb4edab6a619051f149151ba4e7d908d975e785186f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25cf9b3a6299a91b16a04844a99e8ddde848c7ecff38b40e8c9cf34118d21160"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a6aff01a8ea99702983a592e6e46ac7e52a3a08edc202433880852874adf63"
    sha256 cellar: :any_skip_relocation, monterey:       "bab2b1ff62e6cb0d75ea038c793768271d0eda8628cb32a0be0aaa3622fd168c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8155e01739e1c84ee04ac8f176610bacf329a2353b63e4babbc59806bb6bc18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4d86b985fbfce6a0cc4bd0f6de03f9d5705a12aad7a3472df6feef3152c8329"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Authorization completed",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end
