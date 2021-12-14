class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.15.tar.gz"
  sha256 "1a0239c140e762987687f1e52fef929e434d15566f18008ca3251876a9f9cc03"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d3b08f3790610729127e796283fbc9047f68232beab9dc1aa56c59d297e25f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d3b08f3790610729127e796283fbc9047f68232beab9dc1aa56c59d297e25f0"
    sha256 cellar: :any_skip_relocation, monterey:       "8ec722aaa1309eff58336e95755a3702cac0cce68c73bfccc36d4d6b5d8292fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ec722aaa1309eff58336e95755a3702cac0cce68c73bfccc36d4d6b5d8292fb"
    sha256 cellar: :any_skip_relocation, catalina:       "8ec722aaa1309eff58336e95755a3702cac0cce68c73bfccc36d4d6b5d8292fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d401daa88c2351af3b87aa8c1c4bedb38bb1baf92a92bbd20a0e10068780d8"
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
