class OpenapiTui < Formula
  desc "TUI to list, browse and run APIs defined with openapi spec"
  homepage "https://github.com/zaghaghi/openapi-tui"
  url "https://github.com/zaghaghi/openapi-tui/archive/refs/tags/0.10.2.tar.gz"
  sha256 "e9ca7bc160ca6fdf50f7534318589fcb725564c05b81f40742e37a422f35a191"
  license "MIT"
  head "https://github.com/zaghaghi/openapi-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "729ecb681e443c4997743c99d139df413b01406076440c6911ce1514c678257d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b112fae0439ef77af1a9e09c8a410f01e8c1252b844bc2f7d6b60ab9d07d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d599c38c9300b99b49333535053f1b6fc53818c44ee849ff1757a40f58d236d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63b3e891441decfa79e4b67e540c621bd5612ffba84afa88f39331a51288a571"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97601e0e2591e9f91575a45b4aafd1df30bb1a8e70c45c33a0bba5dfc991c66"
    sha256 cellar: :any_skip_relocation, ventura:       "4b3b7fbf36c415d947e3036563cf82f868a041599cb4b9a1f527df18f21a6fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef65bdde2ae8c1e3d8ff7732650b2e7191e3521976ceec10438a1e5151f7601c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1dcf51adfd672b44a54ee82e3e9ba21a8f0021252e50ac40eba70a7ce4e8d5c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi-tui --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    openapi_url = "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"openapi-tui", "--input", openapi_url, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "APIs", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
