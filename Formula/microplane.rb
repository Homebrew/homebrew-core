class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.32.tar.gz"
  sha256 "0332ada57696caab83699784125881b1a0341d6dbaad113de4ade37b188653db"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d696707ea7c919e4ae08ddc692c5f9d41dfa638da82d5d307bc968669312619"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd74b43fb93f9c547805597ccb637ef797952dfd5d7727af0ee89a3badc3509c"
    sha256 cellar: :any_skip_relocation, catalina:      "5b44d11cef464106edb0127d85a3588e3dde5b5353a2e7ea4aeca47779a22eac"
    sha256 cellar: :any_skip_relocation, mojave:        "e381893ee34523c3997b743518433f69cbac74abfd5bf7eab70d0eb16439ca05"
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
