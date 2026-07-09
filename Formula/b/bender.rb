class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "0541a4b536588b05601e02b28e35a7506e04fa877dccd15d7d5d477b0f95ff3f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4330a343a7070d8446296916c499c4115d3061c0355c0532f5cfa9e02f03c355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "634d2f71374c3dcb5f56774f52acfefddbb675015423b04dbc6668b7ced45134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f075187ea729b392f93019ea70389cb1af62ec4c1fdad564c2636eec03b18c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fdc6e303dcad1a187a975957149f9a5c77b090fdf54bb92f3ae1b5509cdc227"
    sha256 cellar: :any,                 arm64_linux:   "5698f75010f323a54810449a8ac2ec63d7b7f07686f0cf00bda249d9de05c1a5"
    sha256 cellar: :any,                 x86_64_linux:  "2c9d63f07c4f3904552a0b23908555b8c848de0cde99c078c8fc16968d741d41"
  end

  depends_on "cmake" => :build # for `bender-slang` crate
  depends_on "rust" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  fails_with :clang do
    build 1699
    cause "`bender-slang` crate requires C++20"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bender", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
