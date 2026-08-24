class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c3e10e136ded670bceb7cad93e95aad282355f728c5f5a1121af4ef1a7c50821"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd8538a1a79473e9a0cef209a20742c6f466186de79b052f8967b258ef9a0426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d61405221c4beb7f5e7cfc0521e56a0dae0fd7e99efe43c61d74de73e5e3748c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c94a61d832b06a3c0fcfd94bc599f2403f44035b557c827fa5ae6a77ae0e060"
    sha256 cellar: :any_skip_relocation, sonoma:        "8062728fbac106ce415d021ef0b738af94ff2b99c504dada3e6fa6b7f7144ada"
    sha256 cellar: :any,                 arm64_linux:   "162c1a50d94e4fe4a601ed6f9f9c17be951a75a76eadf49cc4b45254b8772c2c"
    sha256 cellar: :any,                 x86_64_linux:  "9ae57e94d67b1657e08f72958ba274a7a59b3aef1be3826cd9b4c2fa70643509"
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
