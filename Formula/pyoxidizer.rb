class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/pyoxidizer/0.19.0.tar.gz"
  sha256 "ca0ef41c359ad8ad4217b4c99f3cba4179278308d846f404175183f8ec71067b"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "367f1fdce86f89f92472fc2bdefe8d11da9f0b769d4d36f586d0d2281793f99d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c468f253d4079687e234f63ce05b81f8c56197578a24719cf52a873df27c755"
    sha256 cellar: :any_skip_relocation, monterey:       "5613815563a5da8cce53713073697a1f10899bf7f9067a90ae4abb8986792492"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04cf6692c1a7c569e4c5c6774dffc6169f61b6b2eade7527b544d23372d017d"
    sha256 cellar: :any_skip_relocation, catalina:       "3a5efe1ff4374f50f8c58ad0157ae8984bf609ff740245ad7892addffd5b0dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b940fc30625300fff17268ebd769e3af03a1f0ab2f3dacc1e2f5dc064794a3a"
  end

  depends_on "rust" => :build
  # Currently needs macOS 11 SDK due to checking for DeploymentTargetSettingName
  # Remove when issue is fixed: https://github.com/indygreg/PyOxidizer/issues/431
  depends_on xcode: "12.2" if MacOS.version <= :catalina

  def install
    system "cargo", "install", *std_cargo_args(path: "pyoxidizer")
  end

  test do
    system bin/"pyoxidizer", "init-rust-project", "hello_world"
    cd "hello_world" do
      system bin/"pyoxidizer", "build"
    end
  end
end
