class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.32.tar.gz"
  sha256 "0332ada57696caab83699784125881b1a0341d6dbaad113de4ade37b188653db"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b7a872f754154279db15e1a0b5a046556ed066df8651031245afcbcacea17c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c10da9b7a68a8d6c055a95227581f35641c787d165be6e250bd12061fd51a8d"
    sha256 cellar: :any_skip_relocation, catalina:      "4138178d221fcdae854a4afd3a0b5de02206e2a31be5579d80ac0406cab19342"
    sha256 cellar: :any_skip_relocation, mojave:        "1a98222eb9f5ef3044c64ca0c6031a1f976cca5d2a3d54f56fe1df98bcc3889e"
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
