class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "e1636f08781fdb6e380428bd54f458f59b7764702271a7f2f407ad4432753c33"
  license "MIT"
  revision 1
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b209eb6e7ea2ab96ff812b0ed00730ca4d571e7e54442f18fcb74b387cee8e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e6648172990a699ff1e7cfb8f81326fb56d60381b581c1690be55cdd9532426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2298c377fd5455a0913602df354396f414baaa927c39cf35571a276925f86ac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5cdbd68ce01bc0136fe450a4ba72cb97066c6c5cd26c1bcfaf732a57de40ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ceddf9c4c0b869b36a1cb930e78da8ef2070e591966663c5da0d08946ce9250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f37d409d9caf0f1fcad428658e40211e723432be2f2f4c22db850cc883d290"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Backport openssl 4.0.0 support: https://github.com/codesnap-rs/codesnap/pull/124
  patch do
    url "https://github.com/codesnap-rs/codesnap/commit/536d39dbd5c027c067505bcccb87c0fa16d9771f.patch?full_index=1"
    sha256 "653c5cbeaa032e58ee652400107b73c51583b732322321fa7b85d43e67a7e702"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")
    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
