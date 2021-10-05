class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.9.tar.gz"
  sha256 "892d9a89a947db8fb6565277041ae66e0241eb5c9ab1ef1d854e518bc4084670"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "abfa2a0207f435924e0c19bc6cfc4eb1415c18e78795814a565bae2565ea5d42"
    sha256 cellar: :any_skip_relocation, big_sur:       "dfa04f01475c170f4946301451a780d225df0cd7dab00a0425612a43334923c6"
    sha256 cellar: :any_skip_relocation, catalina:      "dfa04f01475c170f4946301451a780d225df0cd7dab00a0425612a43334923c6"
    sha256 cellar: :any_skip_relocation, mojave:        "dfa04f01475c170f4946301451a780d225df0cd7dab00a0425612a43334923c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11e5e83ba3e3ef3bf735c197e32465be6ddb79a54c8b7bb3d8cbc47cdeb9defb"
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
