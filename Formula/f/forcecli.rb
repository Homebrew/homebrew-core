class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "42c1be7fc1ce9163b2b5f0c1bdb25dcdf2cf78bff90d4ead264709a0e29a11bf"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e270f1326cbbaed1649d084297b2f0d09a0a5b38038935f447473cda74b334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e270f1326cbbaed1649d084297b2f0d09a0a5b38038935f447473cda74b334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22e270f1326cbbaed1649d084297b2f0d09a0a5b38038935f447473cda74b334"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5c5ab619cfdddf8b9c108bf774f8586e44cc780452dc0f4ec0d35d98340db7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f10f90079b97a80384fc543e4fed64a01fc5fe1400a9992d0874f8c2add2ab77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77552a56ab1f96fb504d1f743a3fca5fe627109301be4c4439f8afc9e27acb3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
