class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.10.tar.gz"
  sha256 "c901cbab889bb96142b0f4b1541a4e15e44c099b059be3630febb8a3eeb731f4"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a97edee165122f83383ef75275101bbe439c0be3b70fe3163d18e712602e230f"
    sha256 cellar: :any_skip_relocation, big_sur:       "4953c9212938d79ad5c12b5ea78a6bdd7d9f58f80032644d6b817dfa271721c7"
    sha256 cellar: :any_skip_relocation, catalina:      "4953c9212938d79ad5c12b5ea78a6bdd7d9f58f80032644d6b817dfa271721c7"
    sha256 cellar: :any_skip_relocation, mojave:        "4953c9212938d79ad5c12b5ea78a6bdd7d9f58f80032644d6b817dfa271721c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dac468525dac4237a6cbe08ae0323e5aa14dfd2354fcfb876e778f83493d4dc"
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
