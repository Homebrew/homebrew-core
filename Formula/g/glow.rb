class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "55872e36c006e7e715b86283baf14add1f85b0a0304e867dd0d80e8d7afe49a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "285b38283a9d92de47832c73aacb9ef46db02adf6814e2b3962a2dba321d7f9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2fb47736f87b48761db48dfed4a9590363d9add8862ca9f71ef492e350bd476"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2fb47736f87b48761db48dfed4a9590363d9add8862ca9f71ef492e350bd476"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2fb47736f87b48761db48dfed4a9590363d9add8862ca9f71ef492e350bd476"
    sha256 cellar: :any_skip_relocation, sonoma:         "dce632f932d1e7d7548dafb8187d02b5752f4071505df75905e45bc1858f98b1"
    sha256 cellar: :any_skip_relocation, ventura:        "dce632f932d1e7d7548dafb8187d02b5752f4071505df75905e45bc1858f98b1"
    sha256 cellar: :any_skip_relocation, monterey:       "dce632f932d1e7d7548dafb8187d02b5752f4071505df75905e45bc1858f98b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0a44d1f7c7a47053fc73f3fef4d05e12c5fd30de38d409f875f5d1f5d6e66f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"glow", "completion")
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS

    # failed with Linux CI run, but works with local run
    # https://github.com/charmbracelet/glow/issues/454
    if OS.linux?
      system bin/"glow", test_file
    else
      assert_match "# header", shell_output("#{bin}/glow #{test_file}")
    end
  end
end
