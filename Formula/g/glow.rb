class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "18df6f3c09157021366b8c702b5badba405d37dbb42f132353eb50c1b0d3f464"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c98cc5916747344f2d89f9c0c0900398992e2c85866c600ee5543df4276728a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c98cc5916747344f2d89f9c0c0900398992e2c85866c600ee5543df4276728a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c98cc5916747344f2d89f9c0c0900398992e2c85866c600ee5543df4276728a"
    sha256 cellar: :any_skip_relocation, sonoma:        "928a487495eb5f657b320be84189f8d5b61f3494e738189975fe559ea66a9a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc9c51318c1e09e23649f5025d46302fd4b2b2f7cd09765515b2320834b76aaf"
    sha256 cellar: :any,                 x86_64_linux:  "f3ac00f52053e69fc281dbdb52cd9339fa1a25cca1e139f4dfabdf6d298d2037"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")

    generate_completions_from_executable(bin/"glow", shell_parameter_format: :cobra)
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~MARKDOWN
      # header

      **bold**

      ```
      code
      ```
    MARKDOWN

    # failed with Linux CI run, but works with local run
    # https://github.com/charmbracelet/glow/issues/454
    if OS.linux?
      system bin/"glow", test_file
    else
      assert_match "# header", shell_output("#{bin}/glow #{test_file}")
    end
  end
end
