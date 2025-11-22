class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "11ecb806c1cbedc0dea73d479d300ba8622e88dea1dbe4827d9715849fdbafef"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b306542a787964bc2e2ab55b7c5378a1f196804e3d08b2a1aa406f39d32da9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b306542a787964bc2e2ab55b7c5378a1f196804e3d08b2a1aa406f39d32da9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b306542a787964bc2e2ab55b7c5378a1f196804e3d08b2a1aa406f39d32da9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c4f17575394654085af6a747946338769c074b08ef0f6dae89fa5a3eec52300"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8c1ce1ed45f23bb619a9bda29411bf57c7fd74adb5c03bf7f530812ab659389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e45d03f08d4af657810c27799bbe2f29e3e774abf8a08a5ecd6333667dd69006"
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
