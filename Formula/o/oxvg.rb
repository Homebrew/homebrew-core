class Oxvg < Formula
  desc "Fastest SVG toolchain for optimisation, minification, linting, and actions"
  homepage "https://github.com/noahbald/oxvg"
  url "https://github.com/noahbald/oxvg/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "48cd09db206039b530f9ac8e214a68699a82773c5ed508c63baf080bd4a4e754"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24c91028475223f85643d180b97f51474315e083921a4c77dc0a4817ca65fad3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58e9b787759df7a784982c6c2f2267ae668cc57c4f0a47df9c94ceeebfb5a396"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d818cf245c65e32252a2132464ac2ba2ed0f8a55c39af2067a35429ed70bd1b4"
    sha256 cellar: :any,                 arm64_linux:       "407aa82bb083307f734a13912cf788c3398237b275a3b0a4d24a501fc80fe969"
    sha256 cellar: :any,                 x86_64_linux:      "a11836e2ffbc7946f2384b5d955c7aa0a85f30c554d61dfaaedf23bc9d7914ff"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oxvg")
  end

  test do
    input = '<svg><path d="m0 0l0 1"/></svg>'
    assert_equal '<svg><path d="M0 0v1"/></svg>', pipe_output("#{bin}/oxvg optimise", input, 0)
  end
end
