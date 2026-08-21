class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.3.82.tar.gz"
  sha256 "14c8d19da3280da5ae56207b69b3a7eb0e752c0053ffb7cc4c4bda6db7873e0e"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "987b2e113d7c608d1d11e5354717078779b54e619276a45fc8e11050f5c674bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "921750fc1cff7b783fe3c556a4ec2eceb9be607523cdaab2428b17f80b705434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f46fabc87108b35a3aa54be5193d75a48cb6677c497665300bcf7334b13f0424"
    sha256 cellar: :any_skip_relocation, sonoma:        "d94ce4538e59e6ab55f5e4f1f7bb7591b59e821e920df2bfde86bf5d5fe135e2"
    sha256 cellar: :any,                 arm64_linux:   "a251b96a32f7a80f217d55e0a341a006ace5ddb92c8c0ef9555a172812314c4e"
    sha256 cellar: :any,                 x86_64_linux:  "33532fce1ab29c6a5ddefbcfa81b7d6ff86c873677809e2e29adee25e7ae5783"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"opencrabs", "init"

    config = testpath/".opencrabs/config.toml"
    assert_path_exists config
    assert_match "[provider_registry]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end
