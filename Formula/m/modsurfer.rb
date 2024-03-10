class Modsurfer < Formula
  desc "Validate, audit and investigate WebAssembly binaries"
  homepage "https://dev.dylibso.com/docs/modsurfer/"
  url "https://github.com/dylibso/modsurfer/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "2f5defcfe8668d7323a83dab0b323282e2855a4171c1d0d4eacf5963aa3729b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f29d1bb6b9cec6ad202b14117cf687c84443f3f61a240d6048a20e62cbff617"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00f907e4a00c41835f0b001b54c00acf7785ae2bf28204a56ab59a047e58b77e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd6a1186fd7f80a41d7fa70c30fed374fba4ed12a048dd7048adcaf4c9a704b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe3fc7a7b1fb3e253f78b900db223e8049b5473cf2c6346128477fc072b418b0"
    sha256 cellar: :any_skip_relocation, ventura:        "4a7fc8d8bf01e5a136afd6c20d9f8718a8151e287f96ca404db161d39dce0871"
    sha256 cellar: :any_skip_relocation, monterey:       "98fa1a01408dff568cc9b7f4038fc3699df5702bdbcb6c96826eb6fd4f4b4807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc4541e3ed2f0dc6c73cae8443e8f86d17abb6948fd27e222c1933d353ee1f6"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/modsurfer -V")

    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)

    system "#{bin}/modsurfer", "generate", "-p", "sum.wasm", "-o", "mod.yaml"
    assert_path_exists testpath/"mod.yaml"
    system "#{bin}/modsurfer", "validate", "-p", "sum.wasm", "-c", "mod.yaml"
  end
end
