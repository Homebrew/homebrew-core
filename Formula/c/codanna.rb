class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ea3cbe407e92395f670f990bd4be875685791e768a65eba1895dfd41f35b28b2"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "100a39f74fb3e8e17cdb169d598cf7fd3d1c3a23e6d9cd48c9cc974b48e1096d"
    sha256 cellar: :any, arm64_tahoe:       "3cef99bc6abc1b9d61cc977969eacc9dbce3004062bbd50795f06a4be04a6cd4"
    sha256 cellar: :any, arm64_sequoia:     "e14d57e637e7eb8b88c0915df107b9939455c3bb0cea7c2a2558e257ba4d92fb"
    sha256 cellar: :any, arm64_linux:       "68cb6c732f1b89a694966250dc14d34e6786b09f07949e2f85d717c9c81be4e0"
    sha256 cellar: :any, x86_64_linux:      "07cc8b41fd198eeccb4cac1452a4eaf941fa7b8c7936c2eee66f460fe942b8a2"
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
