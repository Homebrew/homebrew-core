class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "3fa152fb9e2517d4ff9c9fcb90c078d95eab9ffd40fe31d6af69cc17fbe97ab9"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78a5b627934836eced24c5ef93313bbb2e1740f4b84fb8cff18fb7e87faf2b08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84713a894c0a5479b576a095171c6cf2b57531723ceb24ef3b2e504df5b47b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5dedcdb33bb7c14212c0232b1a5d9ce8298c3f0b2767f78f498d721a27bf9fa4"
    sha256 cellar: :any,                 arm64_linux:       "dbf45f8ccf4926c545949e131ebe88d69c3c2921613d8d3186030c5dd41101bd"
    sha256 cellar: :any,                 x86_64_linux:      "7ba2216f36a9cb0ad11ebf605a27115a1a051f61f78e2fcb0c6ba0a5ad1f1efb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    # Drop upstream's x86_64 Linux lld linker pin
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid")
    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid-hook")

    (man1/"pixtuoid.1").write Utils.safe_popen_read(bin/"pixtuoid", "man")
    generate_completions_from_executable(bin/"pixtuoid", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pixtuoid --version")

    # The test sandbox denies binding the default endpoint under /tmp
    ENV["XDG_RUNTIME_DIR"] = testpath
    assert_match "delivered a test event", shell_output("#{bin}/pixtuoid doctor")
  end
end
