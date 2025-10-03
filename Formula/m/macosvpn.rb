class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/refs/tags/2.0.0.tar.gz"
  sha256 "bf91fad369d616907d675be39de7d0c6a78ac0a8c184b59c0af2b6b4a722ca74"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b5eb27f50fea31e5fba9f320ee8a43ce8a1a393507a9a892864712fd37f73f5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7ac4947917a99f3fd96ac3a81a6dbe18be590d25df2bfef024dd0c3e564e9b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35c57637ae70f1265c5cc8df4f370e89eb5fcc441bda03ce4c6b3c294d498899"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba041bd58d4f5a2c58e25ba148a1e9381e0c1f9144661f3f0c0e039f0140c993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05556552fac0910a7f96aa82a60d84fb81269399183eb1c44262536eb898fd9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca5acfb04df29355633ded3a1c63b35e6c8f2cf63f0f76b065b35e3cad76e319"
    sha256 cellar: :any_skip_relocation, sonoma:         "c921fa16adaf91069156266afc6930ebc2dbd580e3653b099336e0154e7a2e3f"
    sha256 cellar: :any_skip_relocation, ventura:        "4bef08a42e37828e824db81873a433b47843e64ffeaba297fd0a190d9bbe2301"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a039a15c681f44320e6cefc8d2b87f035ec25aabb5919adbc65656889d95c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a85ae6d100ebe8ce596b3c430784083c4bfec7b833c8abb630b5838faaec8b9"
    sha256 cellar: :any_skip_relocation, catalina:       "a23588080999163bfe86a43034b4caa6bfc09c5ab6dde3a4cf09ba6c6d5c1209"
  end

  depends_on xcode: ["11.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 2)
  end
end
