class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "c2e95054ed9aee5a304dc31e9b25f2a945d52764352eec399b007e8214e10a0c"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fd031098d332d234bd90c2e6027f9c8b95b691f0075ef2acd14b2ad46e2206e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd031098d332d234bd90c2e6027f9c8b95b691f0075ef2acd14b2ad46e2206e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd031098d332d234bd90c2e6027f9c8b95b691f0075ef2acd14b2ad46e2206e"
    sha256 cellar: :any_skip_relocation, sonoma:        "113486d4f7246d7f8f7b7f0508dca32e0692ca5dca7824a995eb187b1d63b113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ef6c7e200d40f3db0796b752e6220b7d130931a39984e62d63d07fd7e3ce1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7f33899d93564d0a57ad249e106a406edcff238c1f673b06c38f6d43a33474"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gotpm"
  end

  test do
    output = shell_output("#{bin}/gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat /dev/tpm0: no such file or directory", output
  end
end
