class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/1.1.1.tar.gz"
  sha256 "cfc0b7438915c0994b910ab6bc91b04ec129146a74e3efb85d35860f7bf3a9ac"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "599aa60935bfc55cc8efcbc6419abcee14066c1f27ff0b52bac065afe3913ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4135f0f902433b5f6517339b33abe70c39f0945834ab412108af1f02c3daea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8348e1e2f070fb4c81974c57c04640e0a34c95333fe197b0d4c3efbc3ba1e63"
    sha256 cellar: :any_skip_relocation, sonoma:        "de6885db4c9bb6656962756eb9b68a96046b7c8765cd40c93e3811a9cb80d484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9418fa3f4b72e88409b52736a0e0ebb70d31749edd77fc3259e1b2767d5d9b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "477ffe5eef9b02a4ac55d57f631be75c7eda149cd18005079b3f768e527b2ac0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
