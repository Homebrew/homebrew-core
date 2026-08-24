class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.3.83.tar.gz"
  sha256 "8cb6bf692625ef50e2f560eb4460b033ddeacb4855192256fea933735c618776"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d53a182e8d86dfe0d8664728a89085d437a5b93af3bf47a3e2f10e5a7b225fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8f47ae857ff526d7c985156121f31885f2a773f3ff0804207383d43ce3f6fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c5c8529547f2ebd2059c08573b8b4714eb3e2be5c637164b836e307081a02d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76d2d330246cfd685d8ffbda6d77d71714487aee018af44a67000249fbb9776"
    sha256 cellar: :any,                 arm64_linux:   "2ee3ac74f3bea635e452358c8386fe34f027168bab3c937779eeff3038c78b1c"
    sha256 cellar: :any,                 x86_64_linux:  "f7030d069e0759b642187ff04ca0aaab82c15cd7408b09bd2a8a45b81ba2200b"
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
