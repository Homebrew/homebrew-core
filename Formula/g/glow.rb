class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "f13e1d6be1ab4baf725a7fedc4cd240fc7e5c7276af2d92f199e590e1ef33967"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813e4db0b1535807ff2d01f01e45e00958df8e15ed78ed77e81b26634c6de8ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "813e4db0b1535807ff2d01f01e45e00958df8e15ed78ed77e81b26634c6de8ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "813e4db0b1535807ff2d01f01e45e00958df8e15ed78ed77e81b26634c6de8ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c5e81f2c3b6dcdbee52aec59b60cfdb61418e240deafce26f45f6b405c6b8c3"
    sha256 cellar: :any_skip_relocation, ventura:       "6c5e81f2c3b6dcdbee52aec59b60cfdb61418e240deafce26f45f6b405c6b8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ff701d58eacc08e527b0e6838462149784ab384a2ac7821bb90f2c5f4f96c6"
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
