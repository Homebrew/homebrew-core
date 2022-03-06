class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/3.0.0.tar.gz"
  sha256 "0c17b58a6a7bb48221e1a5276e39909937245e20636e21b5e11e351a10b11205"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5f87d9e286c2b294bb157ac9f87baa2720fff044c7a92c0b80b9cb82db8a87e"
  end

  depends_on :macos

  def install
    bin.install "scripts/dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
