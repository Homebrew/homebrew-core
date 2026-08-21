class Comtrya < Formula
  desc "Configuration and dotfile management tool"
  homepage "https://comtrya.dev"
  url "https://github.com/comtrya/comtrya-dotfiles/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "13b7b08f484ec4e0c4a0a10bc36bb281bd74b066283847a9d89f4bc83c5c7ea6"
  license "MIT"
  head "https://github.com/comtrya/comtrya-dotfiles.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f1149da737d749c1ce81c8d9e386dbf7c9a2fe02b94be4e4a1c8204a222e8c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c24cb87343e6ab216141ed61cf1d7ab9865e92254b5c49090a90d322c8ce198e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aeab3fb6b90a68791ac4fc53f29806d44567f192e6a2057db47a0931c033ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f8a7b164d73236ca434f4c8c8ba873abe1514d5b8ea2d038bb304cb9ae89df6"
    sha256 cellar: :any,                 arm64_linux:   "213fed84dbffc53e71e18d992e7db6571c6c6f330c7d33c0d84b6f8757e3db2c"
    sha256 cellar: :any,                 x86_64_linux:  "be75b9e7b4108f3fd88b07c2f69a94635945c844000b0f2ddc5d0691467b1fdc"
  end

  deprecate! date: "2026-07-09", because: :repo_archived
  disable! date: "2027-07-09", because: :repo_archived

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "app")

    generate_completions_from_executable(bin/"comtrya", "gen-completions")
  end

  test do
    assert_match "comtrya #{version}", shell_output("#{bin}/comtrya --version")

    resource "testmanifest" do
      url "https://raw.githubusercontent.com/comtrya/comtrya-dotfiles/refs/heads/main/examples/onlyvariants/main.yaml"
      sha256 "0715e12cbbb95c8d6c36bb02ae4b49f9fa479e2f28356b8c1f3b5adfb000b93f"
    end

    resource("testmanifest").stage do
      system bin/"comtrya", "-d", "main.yaml", "apply"
    end
  end
end
