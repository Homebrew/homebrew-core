class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.60.1.tar.gz"
  sha256 "f8745160e5c36190d6d0b69377fb8a5bd1aa2961f1b0a6a289218b5c11cdf7c7"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcc37931a692a807150458a75d3a2edaaa53cd114e0a7bb069a2883aeadbe504"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e774840036510fcc494b96840823af942c6060e6e257c8b9ab242efe90889586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac6ba12290bd133009937e3613ed6cbd2de1d9977f39d40ca59389f04c57ff40"
    sha256 cellar: :any,                 arm64_linux:       "bd5a5b9dfcf06b29440b5e80291e31ad6d87f3ea5014c550a9cd4d3afb5fe652"
    sha256 cellar: :any,                 x86_64_linux:      "4f81b1da5322441b8262088dd82819cbce67203991b67a1e65037224afedc51c"
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

  conflicts_with "goose", "goose-lang", because: "both install `goose` binaries"

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
