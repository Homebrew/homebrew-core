class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://github.com/casey/just/archive/refs/tags/1.58.0.tar.gz"
  sha256 "c8a36e6e9397f2fdfcb0cc246fcdb790b52a784f3c8cabc0d8baeb031852a148"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbfe7f2ddced1061dc574de5c7d0df46b80149f0e3758e82fa076a8417688e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b6e2a432e18920c364fc300e3c3f53d006f90855e3abfea3e3f22359b0c421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131bb36dfd81d9a6387a4419924a917681649f274f1a3242067ad4e6843a3623"
    sha256 cellar: :any,                 arm64_linux:   "5001a24b3bde899db40bdf1483e90b7ea06237fa0f4a83b68dadac784389ecc4"
    sha256 cellar: :any,                 x86_64_linux:  "449c8e67068a58b95060625e36ba162c0680db8c682b0c1e8596343296004521"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", "--offline", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
