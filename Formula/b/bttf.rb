class Bttf < Formula
  desc "CLI tool for datetime arithmetic, parsing, formatting and more"
  homepage "https://github.com/BurntSushi/bttf"
  url "https://github.com/BurntSushi/bttf/archive/refs/tags/0.1.4.tar.gz"
  sha256 "21b265959403c02406137adac1012f676a25ad67d6fbf29a553b9e459c7bbc73"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/bttf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2dec3d0979ba353bec5b6383149bf2aceaaaeb90f02adaa2ab56e41d7610657"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9735d9d3715dbb241583d0cac7a8d054b0833333de3d596ae8926d3c8684be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e85e7ce385c902afa7058cce65c1170cb24171f0c227cc0a186dfcfbfd22567"
    sha256 cellar: :any_skip_relocation, sonoma:        "357cdc8676c5f5954c063292ab90357ef7e69eae4adb7008b2752265a6b2bfd1"
    sha256 cellar: :any,                 arm64_linux:   "a80a228db159c0f4c60fe8f38c3fa0bb89a06fced1f0f179acd3c688ae0a1cdc"
    sha256 cellar: :any,                 x86_64_linux:  "1c399b8ac5e23a0da09e3f9218fcb79f1751698d4f03b291250d70a9feeb2455"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bttf --version 2>&1", 1)
    assert_equal "2026-06-11\n", shell_output("#{bin}/bttf time fmt -f '%F' 2026-06-11")
  end
end
