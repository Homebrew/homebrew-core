class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ea3cbe407e92395f670f990bd4be875685791e768a65eba1895dfd41f35b28b2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4378f8e357634dd62e1b4b1ed450eff6a5efbd5d19da8a2c36136a7198de404f"
    sha256 cellar: :any, arm64_tahoe:       "b3c20a7d42cb78cf6df442d9da18efc4d358978006b2ce66af2e007ea6c83e51"
    sha256 cellar: :any, arm64_sequoia:     "8f69b1a6742cd4f8cb33dd0e45ce5f42c061bbc614a4cc1286419da48bf8b67b"
    sha256 cellar: :any, arm64_linux:       "a60de091571742fff95ad733523c9a3d3cdbc6a3ec6d21fad147e7f254e78442"
    sha256 cellar: :any, x86_64_linux:      "984db8486d5ec598f3e199514cb16da4587da8bb56116227248029626d9c9921"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ORT_LIB_LOCATION"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: formula_opt_lib("onnxruntime"))}"

    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
