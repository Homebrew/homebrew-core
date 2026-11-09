class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "4b08034c49e2217d62a408e026435a71435abc507a4227c14e2e2dc6a6155dd1"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb2eb347d7e70bf6275057a9abe945905a045bc958122c899817e0d9fdedb209"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7103dbda559c01f99f25cee5614b5fc3a3d420b5aa8e9efb34bc693be50668b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ca3ab4b132f332eefe5f988196b9feab08e8a1d0d045625f12bbd62a36ca3b1"
    sha256 cellar: :any,                 arm64_linux:       "e931e3175d8bbbbd621fa1775d134ce76df245f05821b6ce9a3241f3fb441a98"
    sha256 cellar: :any,                 x86_64_linux:      "ce446ddf38348eaa5a90d0511de36bd2c854274ca18953b9a835820316ef20d1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  # Remove when goose's `llama-cpp-sys-2` pin ships cpp-httplib >= 0.43.1
  resource "llama-cpp-sys-2" do
    url "https://static.crates.io/crates/llama-cpp-sys-2/llama-cpp-sys-2-0.1.146.crate"
    version "0.1.146"
    sha256 "9b291e4bc2d10c43cd8dec16d49b6104cb3cb125f596ec380a753a5db1d965dd"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    resource("llama-cpp-sys-2").stage do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    llama_cpp_sys_2_version = Utils.safe_popen_read("cargo", "tree", "-p", "llama-cpp-sys-2", "--depth", "0")
                                   .lines
                                   .first
                                   .match(/^llama-cpp-sys-2 v(\d+(:?\.\d+)*)$/)[1]
    odie "Check if `llama-cpp-sys-2` resource can be removed!" if llama_cpp_sys_2_version != "0.1.146"
    # Backport https://github.com/yhirose/cpp-httplib/commit/02d38251495ed7795305ad5bf34b3e20b9b52156 for OpenSSL 4
    resource("llama-cpp-sys-2").stage(buildpath/"llama-cpp-sys-2")
    inreplace "llama-cpp-sys-2/llama.cpp/vendor/cpp-httplib/httplib.cpp",
              "X509_NAME *name = X509_get_subject_name(cert);",
              "auto *name = const_cast<X509_NAME *>(X509_get_subject_name(cert));"

    system "cargo", "install", "--config", "patch.crates-io.llama-cpp-sys-2.path=\"#{buildpath}/llama-cpp-sys-2\"",
                    *std_cargo_args(path: "crates/goose-cli")

    generate_completions_from_executable(bin/"goose", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
