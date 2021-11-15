class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.34.tar.gz"
  sha256 "289b3df07b3847fecb0d815ff552dad1b1b1e4f662eddc898ca7b1e7d81d6d7c"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9683ab03d43b65a9b9f2800126aa5ebe96fa9c639dbe9d5bdd86d53334fac010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb8cd7544c9c9801ea665666d9a0abf44fbc9a38c15e4749d2137ab62a4f33ff"
    sha256 cellar: :any_skip_relocation, monterey:       "08f86bc537d804034c176ab2445e7caeae118a7815500655456a30a57fdab75d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad84fa0e4efc89cd232632aec23c676ebfc23f787037f0da5a8356dc0b765028"
    sha256 cellar: :any_skip_relocation, catalina:       "f9e918678833d61cedb4decb86652ccc356665aed0febcc48b30d950bc8c9b71"
    sha256 cellar: :any_skip_relocation, mojave:         "5105e70832a0200105c87bf33d04e4852d7a01d8eb05ac9d7f7d3816d3f8748a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2439149f7ad75feb2d3bc41479fb626f8916b1e0796eeef71b69ea630b8afc27"
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
