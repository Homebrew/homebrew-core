class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/refs/tags/3.1.0.tar.gz"
  sha256 "5f45a9079da6b3cb7e832ae0dd8c10cddf96fb8ab9096a6c5cf74bb9f09950e7"
  license "Apache-2.0"
  head "https://github.com/kcrawford/dockutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e35b809622eed751d0d6982b046afcdf838f4af479784b3fb82929620f0db820"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4162b5944b4d4b1805d309a49eb44630ffbb203444c5c15415ec103d61d6551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b47a78564def977a9666b44f7739d39d19d875d4da799c6cea9f04a6a9869ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "40be9f983676beb5416299a836457652334b62027fd9766d2eeeecdba2a91664"
    sha256 cellar: :any_skip_relocation, ventura:        "131155d00eb12023b451bd9f72bac88eda51144b3a8c72e8549b4d7c29ba305c"
    sha256 cellar: :any_skip_relocation, monterey:       "b111b56cb2fafaf8587e9e33182f53dcf5b54da2060de0c2446bb9aa3ee81269"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
