class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/refs/tags/pyoxidizer/0.24.0.tar.gz"
  sha256 "d52a2727a18a3414d7ec920b8523ef4d19cb2e6db3f1276b65a83e5dd4ae8d24"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^pyoxidizer/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c7abbaf7e9a5308e6235da7568798a3520450eb78626615f08a40f5739de5a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fffc8fb7d0f4c1c4743521228edcb637b4ec0969c488f669ca0f49abba884f3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6124e2f8cd40cd7462fa28f70b719edce33751cda845bc1a56284b94290275a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa37a4ac504621090ea1f67abee2694e8c6798f5f8b35dba0f67411d70c9e133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a2e334bd1345638385aa4d56b635b8faecb5095607ed4f177660965979478d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6286b57cb42b275d4f6325e17842cd49bc6bedb9804616349a95250e96eb8294"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ef7aac85b9e30d86343ca1e51b84991ad4db83aff58bf885aef6b43218005ac"
    sha256 cellar: :any_skip_relocation, ventura:        "46aa367ab70a1488edd31411f85942a7179c090feecd1cdfa46735668d80b457"
    sha256 cellar: :any_skip_relocation, monterey:       "ea59d68a7bcdf1237d3eb72348901ea846546598194a44758e4db2521cc38880"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b9f21cdbd215dbaf5c0a41e70674244b4e192e6a64e6a4e1a3e03c933e4670a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b3ddb85f14631d16c2ab17e117fb82e8a418bacce1c5dd54a6fe848dff4e13f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0648492b46bc163e396b0e6e2ca99350a937476050c158dd5d8a32b9b0fc102d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pyoxidizer")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyoxidizer --version")

    # FIXME: restore brew `rust` usage if support is added for newer Rust
    # system bin/"pyoxidizer", "init-rust-project", "--system-rust", "hello_world"
    system bin/"pyoxidizer", "init-rust-project", "hello_world"
    assert_path_exists testpath/"hello_world/Cargo.toml"

    # Intel macOS runners are slow enough that extra time from fetching Rust causes timeout
    return if OS.mac? && Hardware::CPU.intel?

    cd "hello_world" do
      if Hardware::CPU.arm? && OS.mac? && MacOS.version < :ventura
        # Use Python 3.8 to work around:
        # https://github.com/Homebrew/homebrew-core/pull/136910#issuecomment-1704568838
        inreplace "pyoxidizer.bzl",
                  "dist = default_python_distribution()",
                  "dist = default_python_distribution(python_version='3.8')"
      end
      system bin/"pyoxidizer", "build" # FIXME: , "--system-rust"
    end
  end
end
