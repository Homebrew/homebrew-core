class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://editorconfig-checker.github.io/"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "bc0001cf4d3fede6fc1010c25e7603b5c6f36dc6882e6de89aad1612ef4447c9"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df5cb764b30f5b7c95a69fbd9d061a8c0b6af4869cb09163a49dce1587f576bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5cb764b30f5b7c95a69fbd9d061a8c0b6af4869cb09163a49dce1587f576bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df5cb764b30f5b7c95a69fbd9d061a8c0b6af4869cb09163a49dce1587f576bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "82281d903493fd93150f87331a26e1db083fe8da830e7f96e9dcd303e1c1c879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "696afefa5ccd4d480b20ae74a88c15f493fd0dfee2cc2fd65f20db7076efc9ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2a2a2d36e9e6075d7bf8fd1462a48d67b86bdced5051bf2dba1cf5f4f25208"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/".editorconfig").write <<~EOS
      [version.txt]
      charset = utf-8
    EOS
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
