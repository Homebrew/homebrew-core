class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "d1cde4a4bb82385d7cfa964b9910cc2bac85273a8088471a50f0223838fbd39c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e371825c17668686b58b1671f3edfbd741246f1de2e07181d183d8ab813439c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c46a168492660445de7af3943614a6daa6a9931ab009f9015520b36d4059853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4cd4b6b4cbef4f6c932f7cbffb9e6a314ccdceb95dae1ea64fda16c547f638a"
    sha256 cellar: :any,                 arm64_linux:       "3591c713e412fd1886740950c9d371b448c7b5ecf8613050c527cfe6518a5fb2"
    sha256 cellar: :any,                 x86_64_linux:      "74f2dfcbbeff262a14d15eda0af3afc2cd7d70e95e08a64a0b24641ac38cb6c3"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
