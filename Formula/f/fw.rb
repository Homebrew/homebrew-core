class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://github.com/brocode/fw/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "f949c3e29e11688c3ab2a7448b9fea2caf07d89d95da7bef00976541f4d957e7"
  license "WTFPL"

  # This repository also contains version tags for other tools (e.g., `v4.4.0`
  # is an `fblog` tag), so we can't reliably determine which tags are for `fw`.
  # Upstream only creates GitHub releases from `fw` tags, so we have to check
  # releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "eaa4e9987dabe5659dbac380b90c77fffb7c7b8f22dabef470402e2144dfd28a"
    sha256 cellar: :any,                 arm64_sonoma:   "9439cde7e0767daed5fef07280f6b6d8545fa34b637e36fd206770d7593a6089"
    sha256 cellar: :any,                 arm64_ventura:  "df06452ad002deb1ae9228d3fa7291bd71d4c2b9ce7f6fb62fd774641598159b"
    sha256 cellar: :any,                 arm64_monterey: "93860714a4c377a82c1ff7fcd9c11a4214806327ea635ade5fe450e18db83cca"
    sha256 cellar: :any,                 sonoma:         "3810d6ee07419f3061037bdc5702a7ed9fccc3d3fa64ee29ea31c825c83ff917"
    sha256 cellar: :any,                 ventura:        "f9844b68fa6c59d909ffd9a91923e0b676169af3df2606a66ed9ff9a11a23183"
    sha256 cellar: :any,                 monterey:       "100612ba69fff5018c5641aded4920a3fc8830bdf62abc713b8d134ce8b8ca2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057863e093e54e7e4e13a7e82097f3aba99a648bbf528e8ee513c7d3f72838f1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://github.com/brocode/fw/releases/download/v2.19.0/fw.1"
    sha256 "b19e2ccb837e4210d7ee8bb7a33b7c967a5734e52c6d050cc716490cac061470"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install resource("fw.1")
  end

  test do
    assert_match "Synchronizing everything", shell_output("#{bin}/fw sync 2>&1", 1)
    assert_match "fw #{version}", shell_output("#{bin}/fw --version")
  end
end
