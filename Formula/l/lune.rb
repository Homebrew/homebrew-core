class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "b37bdf53dece55037ba00d82fe33a9ace9777cbb42b4d8d6602bcf704c9e1c59"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66dd9283812eed44f847953be3be9f3f20f88a877c7b6e54fef1edf746af62f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c95d39fb6e988e9a3ccc48a598879e42567202cae5b20e132b6f2d40e8307f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc88be7242f2cae984add6a40e9f3efc0f05140dc44ec048a1e0b233378afc25"
    sha256 cellar: :any_skip_relocation, sonoma:        "766dd9acdb9e5410ee956303e46616e5636e725fddb796c74d672bd29df610b6"
    sha256 cellar: :any_skip_relocation, ventura:       "76a66458220aba79755329956111f68eab81478cadc9ccc93c744cc52f588f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c74c1dfc512725d628cfc9900a8844aab44b16b040255c0de08533b55a2768"
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
