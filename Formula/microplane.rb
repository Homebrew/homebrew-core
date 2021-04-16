class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.28.tar.gz"
  sha256 "6d24208a9875331bc145ba0e81578f539c4a7598d7991505ef7a2ead2f929f6f"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea108269c818c010b2e574dd07b274a564712bea6a67b46f5cfe86a38613b885"
    sha256 cellar: :any_skip_relocation, big_sur:       "73b9a26088fff4bb9c6857109f5c6d6001e6940963f66009b9447a8e384a872d"
    sha256 cellar: :any_skip_relocation, catalina:      "d08fe5e47f496a5bcf154633d763b0ac716b88761dda334ae523a741946f7d28"
    sha256 cellar: :any_skip_relocation, mojave:        "d84893f2e1751ededad033263111b0dad3617e7b0f229befec8dd56b51d06be9"
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
