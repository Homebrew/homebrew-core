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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be1e8e994a31aa381e157b5c02cbecf9f4125b94636b3fcab03c5df2daaf7754"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abc045af354034e4b319f920ffd5f454aca1361bea70dfcd3e055867a675d69b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1049a162cc84d95347215da6c5509829205afe12ecb3614a435bfe6c78cbbfd0"
    sha256 cellar: :any,                 arm64_linux:       "05ff7dd97e0d21a987ccdef6585e80d3fbf8a4a959435024441779b09daab645"
    sha256 cellar: :any,                 x86_64_linux:      "1d898ca660874312ed2d6b924abc53e81bbea764e835986fa5efb737b8c3dccd"
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
