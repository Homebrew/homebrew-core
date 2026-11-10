class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "e3d194509db091bcde628a7987bf00d46fd6acb7931a1bcbae8ce74a25e89138"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ddd6ba5619e6a9288dd26e1a5ad3bef4fbff9269485a80cec2213c89287baa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4701786a7b4e08c0f1f6207dc2be80f1dc6e98bcd2cb00de04fa3488ec656dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa2d233987e7589fd38d64582e040638d25947d3d178ca1923fb9171e5f7f72a"
    sha256 cellar: :any,                 arm64_linux:       "6e91f2eaff552948981c6e5509669fd437b789f03b3b066a838685be30e7a89e"
    sha256 cellar: :any,                 x86_64_linux:      "0dab34671c9bb60ba4e708f18f6318f3aa18bd544595fd7b31f46ff7bf0c4782"
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
