class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "5a0e911eac32dd2660e1ef0d40afdbccbccd7ce257bb6be893d6b3dc1f6cb4f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db0d43a2cceedfc0908d749e01f45d272863a2a2ee144be77ad852369739ee69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824e2e873ec3387279774ba5102fecafc19ad1695bfe4d851233a79ea814c69c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5eb38a85098d1f8050ebfa0dc85c2152667a08e5064dc72e9ad9aa1541996c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0e01e334e5f26bc986135591131fd808f218bd2c9ea497f3e1adbd61a02c07"
    sha256 cellar: :any,                 arm64_linux:   "af73e809a5811f819b2cb7e0541ade8ec7cac87bcd394d2a82f4badfddd47952"
    sha256 cellar: :any,                 x86_64_linux:  "e12a9a50fe79bfed2cee76112c32a43ed5980050116f480543d873134d133dae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end
