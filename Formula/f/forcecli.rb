class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "7bda14dfa1a445b97c0e1b3ecd8af63022d3be0092b560962062e6ea09f5dcfe"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ee6b9e0f480090edf979f120a68ddd86733ea75bc98b75b2c699e2806cb685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ee6b9e0f480090edf979f120a68ddd86733ea75bc98b75b2c699e2806cb685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ee6b9e0f480090edf979f120a68ddd86733ea75bc98b75b2c699e2806cb685"
    sha256 cellar: :any_skip_relocation, sonoma:        "13ab3d6014bcc554d550913e48606ac443a8d155654813f90d71dbf0638c1728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a48e330ec1d914c862707874fa66457ea82029876c75826dab81faca0d1c5c15"
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
