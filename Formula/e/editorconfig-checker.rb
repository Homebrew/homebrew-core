class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "e9824828c30f22be07b85618ef72d2e68753315aaf8353a0aade1bdd0a6d7f71"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef4fb857d605eee3fa212a00fe4fcfd8d8c8a26cfeadddaacf95370c80fc22cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4fb857d605eee3fa212a00fe4fcfd8d8c8a26cfeadddaacf95370c80fc22cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef4fb857d605eee3fa212a00fe4fcfd8d8c8a26cfeadddaacf95370c80fc22cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "177d95538d868e6c0550c938f01ddf23870928a100440bc5d78ac0c07d358438"
    sha256 cellar: :any_skip_relocation, ventura:       "177d95538d868e6c0550c938f01ddf23870928a100440bc5d78ac0c07d358438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bda34b9435f7c1901b48a462fb61e17213d2b27a09f3995109c1531074e5eb81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "debf7a2aeeee9904208b3e5b025a062b1f78ff00a5938c166e2b26d95b78cdf5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
