class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "fea998534bfb1e0b91aa6960444468440bafe442f9fa5e197bbe8e7226d230f5"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14b1a20c26fd24166f8ef2ec15144dd3b2628a82611ec3f911f0eef8a5ebb5c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd3c69f1b0190dc44f8bf2b4fe7c8818cc1a1ae66b7e71ec631e7bd4129762d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9970ee97af41143e3b16bbb2a1323e03a38ee8bb517d6a03b32c83039a71d1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb1e7ffbde4ccbed1e9eca2c016c219729db5cd9f7429bea8667c71337a74fb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ebef419c0341e19057868b3adf3985e962cdc7653e01023d670056c990710a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "012f49f82f4349fb5dd120dfbe4f7cbb9bbf8d968c4f9085422d9563bdc78dcc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin/"gix", "completions", "-s")
    generate_completions_from_executable(bin/"ein", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
