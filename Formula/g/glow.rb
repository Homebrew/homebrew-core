class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "f13e1d6be1ab4baf725a7fedc4cd240fc7e5c7276af2d92f199e590e1ef33967"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405c8ef5d9d73d681262c71f23f0ed7961ba5c5eff080e60b8aa54d26064412a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405c8ef5d9d73d681262c71f23f0ed7961ba5c5eff080e60b8aa54d26064412a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405c8ef5d9d73d681262c71f23f0ed7961ba5c5eff080e60b8aa54d26064412a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1520aab400517fb4fc94839296343ef10d585551a37eb36a316722091415fb2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8abf70a282b522fe4a74596f2520b4cfe0b500904f37e25839b13ce2c875b94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ac1b0534794163758eb6c05728732620ff8b595d037fea7052f23633f2f179"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"glow", shell_parameter_format: :cobra)
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
