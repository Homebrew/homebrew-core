class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.1.tar.gz"
  sha256 "8e8c24d30247f055a76674c25af298cdc9775d5268d27a853191409e8f515718"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20caa29a3a97ba173b231cf2a09a5a8f51ce16fa4642b68dc525633206dad9c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0ed8324f81b1e16a3e343cb668728a0a6856ba38e74ca2f04efcc567a09f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb89b0b963608fcb311a3cd4d7bcf180ae6f20185e0811cca8e8d056b01b9580"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa92c3905a359c30e6c8b492d3c2334ffe94bb6e86cf3b5369b4543b777d1ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd285016b19b1ca77c44b6c53a2e8516b3218d77082f36cc66701634e5263ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce4c267f4ae79ffd9e94c243ef4e7dc24d68654cf3aae4b42a9357ee48642b2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
