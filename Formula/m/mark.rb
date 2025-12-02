class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v15.1.0.tar.gz"
  sha256 "0e5b9557d58cbee015ef2b850086c61a74d66f93dcbf596fdfbc253ca508aa90"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22afd639d1c02b682fbf6195e475f6ce7aa60f37c5be6db9b812b08e9ab3b76c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22afd639d1c02b682fbf6195e475f6ce7aa60f37c5be6db9b812b08e9ab3b76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22afd639d1c02b682fbf6195e475f6ce7aa60f37c5be6db9b812b08e9ab3b76c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77db498d45ebec425560bc965a60eaf4fa2d69293dbd8a700f7bb8ff73325f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69811d332f4d791e57a9b70329515e737e3e4f211ffa325797706acc48587560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ad559e82f8e7e0dbfd5ad9746ec1af1b9867239662aa67ec90e7168be180b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "FATAL confluence password should be specified", output
  end
end
