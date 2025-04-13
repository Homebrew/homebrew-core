class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "f1875a73ed81e5d8e6c81443e9a9d18bd9d1489c563c9fa2ff5425f2f8e2af6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd8739a4a46a74b58470bc11187fee3cb54a16070712be0777c47fb2742f4280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8739a4a46a74b58470bc11187fee3cb54a16070712be0777c47fb2742f4280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd8739a4a46a74b58470bc11187fee3cb54a16070712be0777c47fb2742f4280"
    sha256 cellar: :any_skip_relocation, sonoma:        "11be2e19dda176223a008ae2cc898f986c66c843701b1c0709ccdaafa038114c"
    sha256 cellar: :any_skip_relocation, ventura:       "11be2e19dda176223a008ae2cc898f986c66c843701b1c0709ccdaafa038114c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5bf819b4a5d008ee5bfbea78893b8ca67427f1335a8a090185b5691b1f7f79d"
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
