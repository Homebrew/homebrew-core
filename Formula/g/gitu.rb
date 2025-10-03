class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "606f03a6f7877775f270f3ab298fd1d4329f9f039fe06e17ab11d8ae22fbcd27"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2dab29da0d3cc6edb564f9a65372bd93917c262fc7597d131a44f678d3237ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf769db979b184142adb2a4a514ade2be12df132a4bd51e6cf75a507bae89c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c26dc1d6b6a5bb614a3a13615f5f8415dad1f82c9d3de5473ce872878f221d"
    sha256 cellar: :any_skip_relocation, sonoma:        "975574420f181a2bc44e4b167069e8831932f9a4f1bb8a0a91a9b6d1da8e3891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9717a0435d14e4d286328836b574de76b37b167b888695ad284ef7b0ed2f7943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c694adb629b0a123cc200b06480fd60272346125061dc77e60ddd0828062486"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end
