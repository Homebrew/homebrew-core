class Binsider < Formula
  desc "Analyzes ELF binaries"
  homepage "https://binsider.dev/"
  url "https://github.com/orhun/binsider/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "af3b7ac468a5407324b49bbfb750c7426e7d3f08e598195e6a416f10a89afd57"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/binsider.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c28eed38febff2f361d0d6870494fb32b828af9ec51433642207d9404b49486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb32ec3ceff5982cefdc95a64a05d89b5c195aaa7038804fb382a1adac1bc2d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f688b062810c34a518b0cc54d72139f6b70a99af03b6c5cd9fcddb9f7f4bf72c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c47742b904e6d87223592d2ea5a857d3e8165e7acab512e774cc7f2d26e1a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf1abc2334e0307006f469d8e66fd09085811c8bb44f4190c1a5041f50d0027e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c4f8c3d337a688a1b964ff07c8207d4105aae018bd820b0f4de8c44cafc016"
  end

  depends_on "rust" => :build

  def install
    # We pass this arg to disable the `dynamic-analysis` feature on macOS.
    # This feature is not supported on macOS and fails to compile.
    args = []
    args << "--no-default-features" if OS.mac?

    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/binsider -V")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Invalid Magic Bytes",
      shell_output("#{bin}/binsider 2>&1", 1)
  end
end
