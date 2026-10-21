class Magika < Formula
  desc "Fast and accurate AI powered file content types detection"
  homepage "https://securityresearch.google/magika/"
  url "https://github.com/google/magika/archive/refs/tags/cli/v1.1.0.tar.gz"
  sha256 "87fd85f33d2c644d657de024b83cdc36bbdcf4a2961be5e93fe74e081477076c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/magika.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c321c152fc6d3881d82eec2dc7b7074dcc732777bc957c167352e09d13b42024"
    sha256 cellar: :any, arm64_tahoe:       "c79c802ea50529427b1a531054665bb63a5fdd329271d3ec34889d7843e97d07"
    sha256 cellar: :any, arm64_sequoia:     "19909689a749a43590b4d786ec6e495458d7dab75915dfad07a1a0b3fd1376cb"
    sha256 cellar: :any, arm64_linux:       "75ed8f1a5f7d0089003251b77589e827360af6fa0365209002d4af849f658f07"
    sha256 cellar: :any, x86_64_linux:      "7f70b5de59d5d5437a00ddea91b86a2c72fac5bedfac29384659df39f6cceb32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/cli/Cargo.toml"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    ENV["ORT_LIB_PATH"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"

    system "cargo", "install", *std_cargo_args(path: "rust/cli")
  end

  test do
    assert_match "text/markdown", shell_output("#{bin}/magika -i #{prefix}/README.md")
  end
end
