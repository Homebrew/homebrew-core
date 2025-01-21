class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/refs/tags/3.1.3.tar.gz"
  sha256 "622bbb5c97f09b3f46ebea9a612f7470dd7fb6a7daaed12b87dee5af7a0177f6"
  license "Apache-2.0"
  head "https://github.com/kcrawford/dockutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b316cca52f1d2d41b358aae807d3d64996bd1dd6ff44852ac193075fd8eacd73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e0fb8383a52ed1459e9811a121cc5c4105afc61d11d757564e148f72d4b28ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d8d0e3e19454fc3e958b30f7c1f93bc57cc08f14caa28c2435bbc77504699fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ccc0b78a56bec0d79cd7aa9249b72cb72330a6065d311041ac9d8415289654c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e63bf1404297af85f7e5c20d31f23fee13071b66404bf323a19decdf4d898dbe"
    sha256 cellar: :any_skip_relocation, ventura:        "99b5c036b9ad73b6116ad5656218f55ed97680c6ab5e07921587ba6a10cba74d"
    sha256 cellar: :any_skip_relocation, monterey:       "0486c78b5e464029ce2669026de258e0bdc13ddbcece77db4e589e118b3e2fb4"
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
