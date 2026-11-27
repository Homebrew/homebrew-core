class Oxvg < Formula
  desc "Fastest SVG toolchain for optimisation, minification, linting, and actions"
  homepage "https://github.com/noahbald/oxvg"
  url "https://github.com/noahbald/oxvg/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "9e19bcf36a543d48c25ee52927d46ca75bc8aa1f13b89ee0c1c994a609b7c734"
  license "MIT"

  bottle do
    manifest_sha256 "64b3da6457554fa0781e071ac08d382c2858b2eb85ded904b9b6549d3c7c6ca6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33d9b9d1fdca9db0a98a11364a34a9097cedc37d73efb2db68d143ede1850a6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4558c0911c6064e185015f55134fa71b747170bb6d87e5c51859bc05c5717b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed425126fd2b021155b97455f5119d4e3ad45ec10d75aaa14a20cfe50cf92211"
    sha256 cellar: :any,                 arm64_linux:       "45922232ff63b7d6543a436ea742e1a2fee3d3a3dc4bedf79f9614fdf97db47e"
    sha256 cellar: :any,                 x86_64_linux:      "8526001e312594fe599c8eaa8cd67db4fd292fd317ac56398a2c7f113099023b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oxvg")
  end

  test do
    input = '<svg><path d="m0 0l0 1"/></svg>'
    assert_equal '<svg><path d="M0 0v1"/></svg>', pipe_output("#{bin}/oxvg optimise", input, 0)
  end
end
