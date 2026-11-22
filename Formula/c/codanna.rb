class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "0a98241d0abea775eadb8849a9d9fc3b25408c3f93c585b5d6973cdd250270d8"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "40d41e7e0ad49ece3ac0cd9191c6815933e6c1c8d04468ebf4123a024c5c8f5c"
    sha256 cellar: :any, arm64_golden_gate: "a6454efce134ed0f13a2855290368ca1c7ac792ac81a9e5c199a11e5df9aeabf"
    sha256 cellar: :any, arm64_tahoe:       "3f172c1bb2756bcffc8db5320dc1e47e030837e4d17ead51ef8958a10cba65d8"
    sha256 cellar: :any, arm64_sequoia:     "b19953f290d8a83dd65696649b9e94c59eb00c618d5696e8b9a745c901a3a418"
    sha256 cellar: :any, arm64_linux:       "249aa6b3da318d56bc6f40b8fdb12a019d56726e110e920c4d35a87402d03cb6"
    sha256 cellar: :any, x86_64_linux:      "7ad42dfb66cdd5e54bf00b34941bd15814763f3c3fcc0c61a685ae00ecd6ccf2"
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
