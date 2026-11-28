class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/40.0.2.tar.gz"
  sha256 "1bfb6664c0adba8ff12618e7dd9334921f3c9e5e41c7724027c0949fce826347"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    manifest_sha256 "70422ad21343441c8ef245ff5233754b14fe733ac50b53610e546b759fe1caf2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a333c70caac2d2410e63c898559b3b9a7e0e864193c003cbbcc0b930ae1d8e4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a333c70caac2d2410e63c898559b3b9a7e0e864193c003cbbcc0b930ae1d8e4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a333c70caac2d2410e63c898559b3b9a7e0e864193c003cbbcc0b930ae1d8e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9410b7177019d2f58ea4ccdf62ffa2f44be758fb8c0a57bf8fa02031cc225f3a"
    sha256 cellar: :any,                 x86_64_linux:      "a32a2ecd52fd984f12f235855a27e6d5dbda13784b346083d666f368c9f7b835"
  end

  depends_on "go" => :build

  conflicts_with "fx-agent", because: "both install an `fx` binary"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
