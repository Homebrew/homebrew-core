class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "5c5f7090a541d4e0a16379e825184d10a1883db132596b809ba61684899d71f6"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2912b0fae832bd7537de8a1f0292c6b36ef2bb8abbdeaea3e3d963228bf0fa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6c8422219ca684bf9ee99beef7368e9873d22cd263a3e1f4b19229581515da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63501209621f2d375e63f4ea9d9f27995486b8e408dbee71e7d4935c541c136a"
    sha256 cellar: :any_skip_relocation, ventura:        "1be28a0b7203a206ecbd6f39f526ccee77df20e45d2e14d328224ffdfb513382"
    sha256 cellar: :any_skip_relocation, monterey:       "a9ba2a60837dc653731066dc5254211afcffc0b739e34ef4966b846b638795a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "949695d2487bdb3ac6bf72c5e9012bbdb975e58a91631256a8e789a66b07415d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da5aec096933a40982a801cebd52901774378d00161a75d8d4a886647ea40c7"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
