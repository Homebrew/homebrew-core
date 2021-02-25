class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.27.tar.gz"
  sha256 "1d5d1ee676f540ec98a3756783e18d414596ae3b6c034963588820aefca33f14"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "dd71709815772fbf94f434f77f7426ce0544d2343471cfe7d9c71fd3e7e9567a"
    sha256 cellar: :any_skip_relocation, catalina: "338b41245377f99989cc7ac786af29c075d7bec8764cedcb176fb21b9beb4ed7"
    sha256 cellar: :any_skip_relocation, mojave:   "9adc70ddbc6fa4e70e1b006d33222de211caa09d58773e70d449e974482ddfc5"
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
