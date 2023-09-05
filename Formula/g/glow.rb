class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.5.1.tar.gz"
  sha256 "b4ecf269b7c6447e19591b1d23f398ef2b38a6a75be68458390b42d3efc44b92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c0d7b294dd4a8a12bca0eb53c9dec78c43a98c28436bd949074ba22b6a55380"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c0d7b294dd4a8a12bca0eb53c9dec78c43a98c28436bd949074ba22b6a55380"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c0d7b294dd4a8a12bca0eb53c9dec78c43a98c28436bd949074ba22b6a55380"
    sha256 cellar: :any_skip_relocation, ventura:        "b6552b824d49b18f65dda0a80364c88952e6ec64513ce3fdcff8fb748acccbbe"
    sha256 cellar: :any_skip_relocation, monterey:       "b6552b824d49b18f65dda0a80364c88952e6ec64513ce3fdcff8fb748acccbbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6552b824d49b18f65dda0a80364c88952e6ec64513ce3fdcff8fb748acccbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc5970c0f0ab674039f840c12fdb5e3764bf90c879831e6038bdb6c55ba12382"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
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
