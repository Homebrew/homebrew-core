class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.6.0.tar.gz"
  sha256 "21c3ddffa915f0cd857cef580025a6ff86cdd8b78c6026a2d841d2ca482b48e7"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07aaae3448d74c1135ff5b3e35f8cd8bedd8f0b3727c6b6c7a3b37c5cc669a5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07aaae3448d74c1135ff5b3e35f8cd8bedd8f0b3727c6b6c7a3b37c5cc669a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "a1e76c97a829f2b4bb869c90b7cb52ba89163c97b06910e9b060c9478d5f0a65"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1e76c97a829f2b4bb869c90b7cb52ba89163c97b06910e9b060c9478d5f0a65"
    sha256 cellar: :any_skip_relocation, catalina:       "a1e76c97a829f2b4bb869c90b7cb52ba89163c97b06910e9b060c9478d5f0a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af56963c31d38a4203d8c2bc581e23b0691b4ec81e5792a69b07de80369c1c12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
