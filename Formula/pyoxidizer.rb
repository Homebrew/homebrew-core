class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/pyoxidizer/0.22.0.tar.gz"
  sha256 "16fc48067467d19049476923d82f33b27ba944551ec39d4d129415ddc0cac738"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36363b96a5bb8b74a88fdcccc49e7d0d33de2090e42fd5dda2e75641d2c1a6a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35b6d9f269eae4a5611caaed0fe0779f9f5042cb25bc66a3373d652cc63cb004"
    sha256 cellar: :any_skip_relocation, monterey:       "47b5770b9e916c3a675b0ff6d44340004987dd6d203b3735292d08ee937c930f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3879e10e9c10974220fdbe17b8469686182191d48c58733418dc881bdca23eb"
    sha256 cellar: :any_skip_relocation, catalina:       "19f95c7acf6b1c2ea99c7cd59a3d684a0bff43778612d12bab76076c982bef13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c4948b577a48fa5944423a1a1d148a5ee332ea4d14effe227bef7210b65184"
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
