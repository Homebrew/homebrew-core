class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "1b933139da1d08647bf5b3f112cab9548fdc2b40c056c7fa3d84d8706de5265a"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efafef80669a8776fd80e6126ee3f874dde5cf1ae25260c90ab843543f56c0a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efafef80669a8776fd80e6126ee3f874dde5cf1ae25260c90ab843543f56c0a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efafef80669a8776fd80e6126ee3f874dde5cf1ae25260c90ab843543f56c0a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5147e48f551c32ef0753e98927895c8468ca97a4896b641423640d2d27381058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d45a6d2d331f5409907eab72abfaa9268edf1eb6a9dbf4d75a31347c258d29d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c0bb657054bb32edd7f3823268f2f76b5871edbd731769088eb7e8a30ae2356"
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
