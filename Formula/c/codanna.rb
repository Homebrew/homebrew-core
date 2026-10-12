class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ea3cbe407e92395f670f990bd4be875685791e768a65eba1895dfd41f35b28b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89b79cd16991f36a49f6aaa33c9016f9fcf07f6796f5593c3f256f48b88302dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "429ec3a5a85220be5dc62468ecb72212e42fc4f18fbcc33109129fe0a5e20c69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64077c214f60c4f56e71c73b825a6370ae8d05a1db1427eb5e5b028cd4037d22"
    sha256 cellar: :any,                 arm64_linux:       "b4d760a6d1f4dcdd40339fea3c53391fc5c32dbbaf93aa9e246479ab5059b669"
    sha256 cellar: :any,                 x86_64_linux:      "90f8405226ffd97adf821527f61170341d11834e9f57a3e0081e2107a53d61c8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  deny_network_access!

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
