class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.11.tar.gz"
  sha256 "77072c51b0bec8e78da26ca32fc10f9692628caa096d5fdcd66c8df89d7aa79e"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e1eb8b2175a85a515d266ec0cec2af3a27dd839aa9a5b9dab6638b88b75557e"
    sha256 cellar: :any_skip_relocation, big_sur:       "f40eede5b0a75c6c96e30d8c49edb760075c1bb418ceab20c684b801ee81511e"
    sha256 cellar: :any_skip_relocation, catalina:      "f40eede5b0a75c6c96e30d8c49edb760075c1bb418ceab20c684b801ee81511e"
    sha256 cellar: :any_skip_relocation, mojave:        "f40eede5b0a75c6c96e30d8c49edb760075c1bb418ceab20c684b801ee81511e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f16cc5c2cd96a73bfc9c37421c24caca691bae5bccb16bbb34c75ef5a6c4828"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
