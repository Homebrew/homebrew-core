class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "473c1f32227fb63c30d7f9cfb516158c3157c5b0f497ac4d3a57834756c1c0f6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5895cd2fad0927f9ae3dbb4c3d50e5d690419713807580f5fae7be0bbe52517c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dfbe41882d3de26278c5b4c2ad0dcbc3a6121aa97e805167e4c89611938f0a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b082d2cff38ef0ee70728d05c8afdcb3a6d9a4e8a69a845b03fffd6fb3a3429"
    sha256 cellar: :any_skip_relocation, sonoma:        "7840007f9159a7c778454a67c18e1e2dc52780ad2d2faed51774292027a35222"
    sha256 cellar: :any_skip_relocation, ventura:       "89fb96e2e3fd576a496b1bf3ad0b4fdea3d80fd2f34c871af6def4d9b7ff6455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955dda90856a4cb1b3d91a15a1dc1878aa2fa10b52cc65151de96a914b613995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c5433904dd0840d6034eac5391ef88cac3c17c0890e8eee85bf4705dd58f65"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
  end
end
