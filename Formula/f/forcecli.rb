class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "d75f538f8d8cdf1f7580a28e9c740b3b0f8633dc7163a9fe35b02c8d71139264"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    manifest_sha256 "32d575d123eb4d07addb0ab2ac706a65c545c57d2af9c97011ba4b6412553419"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d90ee6bd02acd6d121f81f17ce4c99a6090195a537efe75738cb381bede29cf4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d90ee6bd02acd6d121f81f17ce4c99a6090195a537efe75738cb381bede29cf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d90ee6bd02acd6d121f81f17ce4c99a6090195a537efe75738cb381bede29cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45832de58a2cc384d7377cfd472979f4def80666e617f40001546edec9a61632"
    sha256 cellar: :any,                 x86_64_linux:      "c153c5b345e2b9e5d72d4e1d1088828c573dff97e1f445e472c73681dc1e1ce6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
