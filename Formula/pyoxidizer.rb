class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/pyoxidizer/0.20.0.tar.gz"
  sha256 "11baf7bac8f869d6458b5aee2cb8ecd7f2d7f170211ee97f979abb62eea22bc4"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "673b3f77fdd82c6fbde009da7461c759d8f6cf2d6090cb76359ee9001b25249f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a636c6b8142fc459301f010519b9fb7085da25940063ed5ecd15dd06d28c499"
    sha256 cellar: :any_skip_relocation, monterey:       "5449fa05218b1d985cfb7bd09e619f2403896732a80446f6599d73c42c9adac9"
    sha256 cellar: :any_skip_relocation, big_sur:        "71b0ac60092c72ab35389de12abecd0ca258ede50f36a83768930b94c6718d9b"
    sha256 cellar: :any_skip_relocation, catalina:       "e3a603c9950e3d8105359b2be8fca39a318a0215353c411bfa22f3eb1f6344ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b7d2be825e2393086f57e9e3e043166e0559c2de3e1170782ca9c6030dfd787"
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
    assert_predicate testpath/"hello_world/Cargo.toml", :exist?

    cd "hello_world" do
      system bin/"pyoxidizer", "build", "--verbose"
    end

    assert_match version.to_s, shell_output("#{bin}/pyoxidizer --version")
  end
end
