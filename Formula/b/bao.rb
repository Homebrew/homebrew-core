class Bao < Formula
  desc "Implementation of BLAKE3 verified streaming"
  homepage "https://github.com/oconnor663/bao"
  url "https://github.com/oconnor663/bao/archive/refs/tags/0.12.1.tar.gz"
  sha256 "1565b3a8d043b485983ffa14cb2fbd939cca0511f7df711227fc695847c67c01"
  license any_of: ["Apache-2.0", "CC0-1.0"]
  head "https://github.com/oconnor663/bao.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "902001da5a2e8f41cf6beae64bafbeb09afda852f859c9360121a9710d74da54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fb0a3ddbaf20c24c8050e582d3e1994a54156e1a9b47e266f072b57a5b6ed67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5af8c440b9b04b038f2329932066c1c7b6e7abcba706a9e6c4b53cf698cd9b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401fc0c9cc95094e12d5b2f89b0262822370b6c64f5702d5cf5d2df60a17304e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca178d36e970e90a16f25b384e7961ca7c63be597efb02af444046647d8caf70"
    sha256 cellar: :any_skip_relocation, ventura:        "ff7108f42658acee8c4b1d9a28e36d0f3c184e35a40a9f54fba7306e375d75ed"
    sha256 cellar: :any_skip_relocation, monterey:       "88fb4b48954de3c0dcd8ad73355a180b3b692c6dd25db11685b02325ffbbbfe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e3feefc227d9089314ac7d2ea25ab2a67ea68aab9703e0003e551626b01e99"
  end

  depends_on "rust" => :build

  conflicts_with "openbao", because: "both install `bao` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "bao_bin")
  end

  test do
    test_file = testpath/"test"
    test_file.write "foo"
    output = shell_output("#{bin}/bao hash #{test_file}")
    assert_match "04e0bb39f30b1a3feb89f536c93be15055482df748674b00d26e5a75777702e9", output

    assert_match version.to_s, shell_output("#{bin}/bao --version")
  end
end
