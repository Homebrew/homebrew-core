class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/refs/tags/v0.0.37.tar.gz"
  sha256 "437f65748272de89b8a6990f0f9fca57addf6ff6f8e4de077869976d2ce36154"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "058584a18f49f4de2e888c746d0d8b1c1b37f426f5112f280b3e3d803f1aea1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "058584a18f49f4de2e888c746d0d8b1c1b37f426f5112f280b3e3d803f1aea1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "058584a18f49f4de2e888c746d0d8b1c1b37f426f5112f280b3e3d803f1aea1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ca2def0a17ca6c5e596c8472f627e8b9af429460dcea2be1ba1e9d2cbbba0d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5435b91897be54e019388f2901e08bd4fe7a2b89106b0c0c8190c4e4d9fc13ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be326eae77275410bf28f9c682a3b34df3143d8e26123749d204aea973f4da2"
  end

  depends_on "go" => :build

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
