class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.27.tar.gz"
  sha256 "1d5d1ee676f540ec98a3756783e18d414596ae3b6c034963588820aefca33f14"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5f59d3025fe6082931697855031cf8ea8c64fadfe401fcfe88458bc9a5514f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b3dd793e96813cfd6ad9fbe6fe1a7fa545a77457c8628bdc0f6d4357199370d"
    sha256 cellar: :any_skip_relocation, catalina:      "30d91e96a2630225e4d3bcf76445fac1da49f8ff16b494fd71844cdfcfdfaa2e"
    sha256 cellar: :any_skip_relocation, mojave:        "8752c0fe43df4900deb88b4fd9fac1ffd1241d7aa2c903801d94c2957dbbae54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"mp"
  end

  test do
    # mandatory env variable
    ENV["GITHUB_API_TOKEN"] = "test"
    # create repos.txt
    (testpath/"repos.txt").write <<~EOF
      hashicorp/terraform
    EOF
    # create mp/init.json
    shell_output("mp init -f #{testpath}/repos.txt")
    # test command
    output = shell_output("mp plan -b microplaning -m 'microplane fun' -r terraform -- sh echo 'hi' 2>&1")
    assert_match "planning", output
  end
end
