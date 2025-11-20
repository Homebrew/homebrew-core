class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "68fd860c274a8ccf7beb4f492ee53922fe3ad70c4bfb396bac2934b3c314d361"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43fc7cb45ecb1bc3562fd405d8838bebb7c6fa1efe2fb27db4aaf6bd4d95f9dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43fc7cb45ecb1bc3562fd405d8838bebb7c6fa1efe2fb27db4aaf6bd4d95f9dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43fc7cb45ecb1bc3562fd405d8838bebb7c6fa1efe2fb27db4aaf6bd4d95f9dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0abdb2961407b483247e6c65dc054a35c3d6d6a833bd9c7aeeb02ca2dda505d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb8d6c2365771e576b2e65f2e8ef242c4a616d1c1df09241b8d7106aa55fcbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e00e70481c04d03b6418051078f2dd0576e57a51576770ba2ec8e639cfe4d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
