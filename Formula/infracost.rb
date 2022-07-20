class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.8.tar.gz"
  sha256 "e431beab103d6e011f5b32b5e67d76580051986c539e0d8ce0b2ea1a4984e320"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9dc55dac3f8587ae600fbe086305f81b6dc58668f1d2ac4fd083fb656a46a91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9dc55dac3f8587ae600fbe086305f81b6dc58668f1d2ac4fd083fb656a46a91"
    sha256 cellar: :any_skip_relocation, monterey:       "dd95876d127f7785067b4556c1c88ae85b50cab557f631ddf5f8432533fd4c71"
    sha256 cellar: :any_skip_relocation, big_sur:        "505aff76e79f606967fe203debbc5be7a639ec7e3eca3ce7f52e7e1b10a58c2a"
    sha256 cellar: :any_skip_relocation, catalina:       "dd95876d127f7785067b4556c1c88ae85b50cab557f631ddf5f8432533fd4c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee4fa7bdb940d7a039dd40dc0cb681bec4a6da49c95a23052db9040c0ee2b40"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
