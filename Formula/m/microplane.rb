class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.34.tar.gz"
  sha256 "289b3df07b3847fecb0d815ff552dad1b1b1e4f662eddc898ca7b1e7d81d6d7c"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce2fccdf3bad8a263e334f78998abfa7e25153c3bd1c66fff8e538981bd481b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "895647aa25e00a690a137ab0fae64e72f075d6bedd3d0f9f9105acc7e3c5c90a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77690629610337917ade2bca586af39148e89df15ce4b1887018c1fdec12fc7d"
    sha256 cellar: :any_skip_relocation, ventura:        "6dc454b63246b9866a58af5a0766c074e504c050d38fd3437bdf3dbbc12211d5"
    sha256 cellar: :any_skip_relocation, monterey:       "a0e54ff13e444e476d6eea2798aa1966937488b4e8f2472be9cf024933b74604"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b4d8f8734017c00dfb4c94d77b0eba42bc0daf01ab637a1d6b239d40b939daa"
    sha256 cellar: :any_skip_relocation, catalina:       "bf2395a35907393bb6603b764e1dd748752ca4cd4e93b64033a6c1942e4aa5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca59189a783f9dc449507d44a21773beff53a90ace19c25181a6cce6ea77121"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mp", ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mp", "completion", base_name: "mp")
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
