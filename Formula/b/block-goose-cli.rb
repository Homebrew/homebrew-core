class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.59.2.tar.gz"
  sha256 "d12f7c727306ab07789b0bb5513f0b70c72d7e8032aaddc05bb1d1fc3e8ed9ba"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca80a1a09ecd35946799e66030194ee71a2f2c2b9e6281c6c73428f5a38f8d12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e1c04146b974691c67d1e70d9ba3e96f4b2d960abcc86876a3262b756cd0e19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a4aa353f3db9efac2c1ae8cb6992c448dd25af07e469bc019f392787f1a22f8"
    sha256 cellar: :any,                 arm64_linux:       "884fc12bc9f4b1167c1fa9bad8d9f36a35b1e843a52dfb86a68f025ea5307301"
    sha256 cellar: :any,                 x86_64_linux:      "e5285d81243a2ff83b5e950c3bfa77360b2fa07f78906a8feb120d40e22ec72d"
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
