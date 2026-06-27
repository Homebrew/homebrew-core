class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/refs/tags/v0.0.37.tar.gz"
  sha256 "437f65748272de89b8a6990f0f9fca57addf6ff6f8e4de077869976d2ce36154"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e76d1c6bcd09c9b3bc0d5e70cc0b03a14c26ec0a7514d12c1f39b721c5a6729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e76d1c6bcd09c9b3bc0d5e70cc0b03a14c26ec0a7514d12c1f39b721c5a6729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e76d1c6bcd09c9b3bc0d5e70cc0b03a14c26ec0a7514d12c1f39b721c5a6729"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e6a5c9e2b0df68456b189f4529acb4045d18e5b22415d8ca7f598d53d4c456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d36f665bd9186d9a9f79b9f4f1112256d0dfb3ec0b7c9fcc6fbd27def5c1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f139ba0db65eb05e492aa1b33d11e10808f335dc36058e042db411ba514d7ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mp", ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mp", shell_parameter_format: :cobra)
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
