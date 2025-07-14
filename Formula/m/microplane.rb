class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "efa78a7b3b385124e73e230d71667a6af45cd294cd901ea25d47031a97c7498c"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3f92ce6eb78de3a8789aeb12afe4c021c98c0c257bb46519a5a85fb725d02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d3f92ce6eb78de3a8789aeb12afe4c021c98c0c257bb46519a5a85fb725d02a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d3f92ce6eb78de3a8789aeb12afe4c021c98c0c257bb46519a5a85fb725d02a"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a8fd778008830116ac7046f6bcaea8e19b647d4660768e337a59359db6f12c"
    sha256 cellar: :any_skip_relocation, ventura:       "22a8fd778008830116ac7046f6bcaea8e19b647d4660768e337a59359db6f12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4a6e1e4dc1ab0adbeb7815c059ae06a93cad65ae9786756dc413fc74614cdb"
  end

  depends_on "go" => :build

  # bump to go 1.23, upstream pr ref, https://github.com/Clever/microplane/pull/295
  patch do
    url "https://github.com/Clever/microplane/commit/3e2f1371e56af6d65fc62af5c306a7d6485321ad.patch?full_index=1"
    sha256 "6ba123167defb192f0f97d6dc918be9a557014f8a0367f6be663232b930e3dd5"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"mp", ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mp", "completion")
  end

  test do
    # mandatory env variable
    ENV["GITHUB_API_TOKEN"] = "test"
    # create repos.txt
    (testpath/"repos.txt").write <<~EOF
      hashicorp/terraform
    EOF
    # create mp/init.json
    system bin/"mp", "init", "-f", testpath/"repos.txt"
    # test command
    output = shell_output("#{bin}/mp plan -b microplaning -m 'microplane fun' -r terraform -- sh echo 'hi' 2>&1")
    assert_match "planning", output
  end
end
