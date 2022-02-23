class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk.app/"
  url "https://github.com/mdzk-rs/mdzk/archive/0.5.2.tar.gz"
  sha256 "292a0ae7b91d535ffa1cfd3649d903b75a1bb1604abc7d98202f3e13e97de702"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "140dcfda6cb0fd9c4174dea54ab773fdf33e5c982290d19b691b92b690005bbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fee53c9fd45936faef71d26b4fd09b63aa210427b9958c9a6dbe59d3eeb4b43"
    sha256 cellar: :any_skip_relocation, monterey:       "7eb13864d25ec8c705244ac9b2ceee231bab3480b851a5aa1821edb14d0be2c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a83366746029b34f303966e7db78e29573894d35e6577f3a307536b21e3f230"
    sha256 cellar: :any_skip_relocation, catalina:       "3849a8d5b995c251dc0ad89a456b87104dcfc6d3c50e0d6e344de90dc177abc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff24a92ce07d5e0c9cb76598f9eae2e1c2e07435fd76760b7b360aabfce7ab4e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
