class Oxvg < Formula
  desc "Fastest SVG toolchain for optimisation, minification, linting, and actions"
  homepage "https://github.com/noahbald/oxvg"
  url "https://github.com/noahbald/oxvg/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "9f6fbc2385784bcca8a3411fbbd7deb690799d0866bc5f5d7cd88756b7746af6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe8efed8cbdeb6a72bea6907b5d0f57b60e226f0a8bdfffd9930dbb2ee6c1988"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ce512a75a597faef9c1109f78cc536f49e8acd2479929d7ef87b3e60f2b1ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "736701722b4b7add1c2de0b91fee9a7731dd051dcd9a440e19dabeb27a1f1b3c"
    sha256 cellar: :any,                 arm64_linux:       "627660ee168249d7445f4437515df4d69df5b71ccaa920b5104b6feacdd876d6"
    sha256 cellar: :any,                 x86_64_linux:      "4b478fb010717f943254a966423c762232dd547984abf5604a3683a48f30aaa6"
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
