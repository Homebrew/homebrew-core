class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ea3cbe407e92395f670f990bd4be875685791e768a65eba1895dfd41f35b28b2"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ccdccde7a98094db3a73ed3f38fa16fd83ac9642f1766c0a2dfe9ac370712ac0"
    sha256 cellar: :any, arm64_tahoe:       "75cb961c938a3ec975bf86450027b23e48c42a20ef8266eb471f90817979b4bd"
    sha256 cellar: :any, arm64_sequoia:     "825c09ed3ffe0659ab8577b6e995fd3549df6bbcb42b2f2a0afdc402a016787a"
    sha256 cellar: :any, arm64_linux:       "99afabc0f7e285559c1ff847b3cef64ee922848cfad6f5ba78e0cacadf2dad79"
    sha256 cellar: :any, x86_64_linux:      "e113e0ef6ce26f8e66cdce21ab9c74aa7930ec43e674055381cc26cc2ff004ba"
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
