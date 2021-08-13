class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/pyoxidizer/0.17.tar.gz"
  sha256 "9117d411b610e29dfd8d9250cd1021afb545550fd7e698b623e913c26114f013"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
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
