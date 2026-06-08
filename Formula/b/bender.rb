class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "adfdf9b77802853a4153b4569cb596a89c493b5dab363f1388ed681c57f8208c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fb2ebd5db3927c9345576bd175e4c29080c075dc43cc8e03850189ace599155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e0307eb1682cbe7a83e2f2c0f28d948bd935769536f4f611e7c2b006c00134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "460db10e51f3d328a264d65829eb2b01ebeadd0a67e44f680077d725cfb6960f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae303684e253f95fe70708e9a949a6f9e48fccaba247bbefe0c6ce6d278a724"
    sha256 cellar: :any,                 arm64_linux:   "4cd1b71d8f8366574c2ccdb970927dc6cac54dcc3b47d41e87260eabce3ebac1"
    sha256 cellar: :any,                 x86_64_linux:  "1ac164653ebd38857071078569d083d6ed835da4bb58e1427b9a28c732e7505e"
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
