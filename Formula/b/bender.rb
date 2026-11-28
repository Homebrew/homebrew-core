class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  stable do
    url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.32.1.tar.gz"
    sha256 "0541a4b536588b05601e02b28e35a7506e04fa877dccd15d7d5d477b0f95ff3f"

    # Backport support for prefetching slang
    patch do
      url "https://github.com/pulp-platform/bender/commit/cd6f11a9826529d4e1968203e9914a62a5c7fce7.patch?full_index=1"
      sha256 "f2c57348acfea4e086d66c4049a428a1b2f4384a853436b56beba784ca26a435"
      type :backport
    end
  end

  bottle do
    manifest_sha256 "d1dc3b997294dd883c8d35e8c0f9326da5f35579cc856a45eea855e14e0c54f2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84d0393345e63606f22bb8c38a7742464449d258606adbd4f65049f64c73bc13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4330a343a7070d8446296916c499c4115d3061c0355c0532f5cfa9e02f03c355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "634d2f71374c3dcb5f56774f52acfefddbb675015423b04dbc6668b7ced45134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f075187ea729b392f93019ea70389cb1af62ec4c1fdad564c2636eec03b18c05"
    sha256 cellar: :any_skip_relocation, sonoma:            "6fdc6e303dcad1a187a975957149f9a5c77b090fdf54bb92f3ae1b5509cdc227"
    sha256 cellar: :any,                 arm64_linux:       "5698f75010f323a54810449a8ac2ec63d7b7f07686f0cf00bda249d9de05c1a5"
    sha256 cellar: :any,                 x86_64_linux:      "2c9d63f07c4f3904552a0b23908555b8c848de0cde99c078c8fc16968d741d41"
  end

  depends_on "cmake" => :build # for `bender-slang` crate
  depends_on "rust" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  fails_with :clang do
    build 1699
    cause "`bender-slang` crate requires C++20"
  end

  # Cannot use svlang/etc. formulae because the ABI of svlang and C++ bridge must match,
  # which is only guaranteed if both are built using the same build defines and flags.
  # See https://github.com/pulp-platform/bender/commit/4fa9b3a97f6f41e3fef4d26444038e8f3b4c76d1
  resource "slang" do
    url "https://github.com/MikePopoloski/slang/archive/refs/tags/v11.0.tar.gz"
    sha256 "50676d5a9adbefb97d266a4b174e6b0513901afd5ac57a6cdfea0a61149c3704"

    livecheck do
      url "https://raw.githubusercontent.com/pulp-platform/bender/refs/tags/v#{LATEST_VERSION}/crates/bender-slang/CMakeLists.txt"
      regex(/GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "fmt" do
    url "https://github.com/fmtlib/fmt/releases/download/12.1.0/fmt-12.1.0.zip"
    sha256 "695fd197fa5aff8fc67b5f2bbc110490a875cdf7a41686ac8512fb480fa8ada7"

    livecheck do
      url "https://raw.githubusercontent.com/pulp-platform/bender/refs/tags/v#{LATEST_VERSION}/flake.nix"
      regex(/repo = "fmt";\s*tag = "v?(\d+(?:\.\d+)+)";/i)
    end
  end

  resource "mimalloc" do
    url "https://github.com/microsoft/mimalloc/releases/download/v3.3.2/mimalloc-v3.3.2-source.tar.gz"
    sha256 "7ced84a659a95454ce08b725af56331164e6b8673310e5a9a5c612576145456f"

    livecheck do
      url "https://raw.githubusercontent.com/pulp-platform/bender/refs/tags/v#{LATEST_VERSION}/flake.nix"
      regex(/repo = "mimalloc";\s*tag = "v?(\d+(?:\.\d+)+)";/i)
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    resources.each do |r|
      r.stage("vendor/#{r.name}")
      ENV["#{r.name.upcase}_SRC_DIR"] = buildpath/"vendor"/r.name
    end

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bender", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
