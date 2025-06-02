class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "e3473cd9cbb0a6233fb96f230c0cbe4d19a2ced4bf833393957fa529c2c24b00"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b3d61c7ebbcb715bd7bf9a9632015a52fa09e0410d89975a84a7b89ac4678e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e72bdde48fa6b8ad6ffa7b6cf62689c2da86f25952d655e986d8ae8db80658d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a7b8dc47047ab805fc37366edd7a5f14fd193fd78390d6763bf763ce83e1841"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d6a98a73cd6346d95c9fd8ceb6cad2c23699a5ce2de7098210241ae28af8695"
    sha256 cellar: :any_skip_relocation, ventura:       "58e3d58db4d133fccba1fbd11c8d82c80bf4034a599de7c51529a60ac4e2bafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "889879e810be625eb12d81b35185cb87c9fef6dd27074c004c8770f012c45fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02542d2394acfd0c723b91ad514bc9a97f20e77c3856bd057f8f28a4e6514452"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
