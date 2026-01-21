class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "57b1c7ed46bf989cd32c274a4e59469661f3018b89ba1cc01c0a0c964495f426"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8cdc8b35552f37e26cf041e08129933a9e589d27331ddd50f613cc80306defc"
    sha256 cellar: :any,                 arm64_sequoia: "2e42f9ab6c6daee4635c25823921551be7ff2d529b5c89c36fff90f437c553e1"
    sha256 cellar: :any,                 arm64_sonoma:  "ddf4f2a76b95914842c745837a128a3bce7394522e6ee762516b46ee7d2aab07"
    sha256 cellar: :any,                 sonoma:        "b25ccf8d7fadfe0fb243acc527850a1e256885d2e3ea9ff4bfd0c88a85a03d15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf5f64d9f0fa52a8d5aefcccbff9fb0110cf9f7f3b7485e7827443241b9a368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967ae9fb8ee80a5f1014b059e03d2a0acdfea197cfcf344a66a6a12d152e9f74"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end
