class Qqqa < Formula
  desc "Fast, stateless LLM for your shell: qq answers; qa runs commands"
  homepage "https://github.com/iagooar/qqqa"
  url "https://github.com/iagooar/qqqa/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "1a47852ade8175570c3b0f6358a2850be4281ffa9511e14cc4240420e4d02a75"
  license "MIT"
  head "https://github.com/iagooar/qqqa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8312340e34624f23b3671566cb746d62693388516dbc63440e98eb462d92d942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4078a12a421c9cc8275b7edacefb8b376692bbc1f6e190b2319aaae78e9cd596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6391ece35a7f749e952e186c2f07dc1a3cfacabbdbb347ecaf838aee84394da6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e930ac79c9748feb95d46f0b9c6fd230c4b83827d971b0e290accc7640c36f49"
    sha256 cellar: :any,                 arm64_linux:   "990d54cdf9e96d1397e0475830f3a205448ea6496acc495ad8cb44727805024b"
    sha256 cellar: :any,                 x86_64_linux:  "1983e792d64fd1b766e56f0ee300743ed55dbd293f1279b8045cd4377fb189a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    %w[qq qa].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    assert_match "Error: Missing API key", shell_output("#{bin}/qq 'test' 2>&1", 1)
  end
end
