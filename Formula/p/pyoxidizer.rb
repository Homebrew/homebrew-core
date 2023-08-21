class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/pyoxidizer/0.23.0.tar.gz"
  sha256 "d96c4747d37686c052ef5a064fda59ac0b175085589cd7cdd4e277906136f8a7"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a438770a4ce6bb1ea06f3d23d1c0cf505f93383de2ff27d99b22d5d5b34c9f51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb62cb641b9b69e0995c19c288a051a5f59e11de3a174aceb4c67daf48332b4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dbd06e01ecb46b93bb3250bd0d5e349295ba6c56b77622d29c64676ed17e3e8"
    sha256 cellar: :any_skip_relocation, ventura:        "4b03858e038e6d7a4a40abf538618704f9b891815766a45492ae41af608eba72"
    sha256 cellar: :any_skip_relocation, monterey:       "80d2014e88d9937d1a88b99da5a8d035e8ac42ccc4df7480512e020e6ee30fb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9aa0d494c359e0f8b16c8c3ae31159d8f540f3f9d7946ca4bdc20bc6a83fe10"
    sha256 cellar: :any_skip_relocation, catalina:       "3d1bc85db1bcbb5f69c8dba9c294d65ef9b674d217f6eab670ccc6eb4dedf812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de042e72b4759060bdfd5fac56d50594614f7c0cab901b8ccf70955a4191191"
  end

  depends_on "rust" => :build
  # Currently needs macOS 11 SDK due to checking for DeploymentTargetSettingName
  # Remove when issue is fixed: https://github.com/indygreg/PyOxidizer/issues/431
  on_catalina :or_older do
    depends_on xcode: "12.2"
  end

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
