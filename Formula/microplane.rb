class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.34.tar.gz"
  sha256 "289b3df07b3847fecb0d815ff552dad1b1b1e4f662eddc898ca7b1e7d81d6d7c"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c50dfdadfca4224c201ca06044a87e540cecbd4d7f2cddc456477f90aa7211e"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a7331b0798fe910e483fb17ae7867462736f727b1c0321a0bfc504f67190e5e"
    sha256 cellar: :any_skip_relocation, catalina:      "3b835af36cf8be74fa4cb40db5263cf9f5b33f1682cd43fb2ba916df9c0a9adf"
    sha256 cellar: :any_skip_relocation, mojave:        "dcb748ddf661e7fa5f839b372a818f046733741783dd01ba16434c4f187ee2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7b4187dc00e5c2d200978f1029751120e99c8b95760c4e6b830b07dd6f1aba"
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
