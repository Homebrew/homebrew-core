class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/pyoxidizer/0.18.0.tar.gz"
  sha256 "e8489e09acdcad9f475638152f5f13bd3d40b8cf84617e8c776c99625643c04a"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af4651acdfa3faf5f92b3ce64e9d376f15fe0ce4ed49ddc8e9c183ef92d7c2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98d982131e452efd1d96c2bd6cdcad0304149974a5ef1a6b6ad0aec4df82f7c1"
    sha256 cellar: :any_skip_relocation, monterey:       "bd85eb94cd02b7ee4c997c0808e85f3b5aced126f835066f2cd3d7ae1967567b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba803d295549da039b58e60d507d81529ea965f54240189a669b2d9b4167747f"
    sha256 cellar: :any_skip_relocation, catalina:       "0e3427609806a42d059c126b63db0d4ef81ed4cd0f89c94f506b12de62bfd923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a282e83f9099a362633df3ba787b9986ab83c249ae7f3e929f025e3fc75d19e"
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
