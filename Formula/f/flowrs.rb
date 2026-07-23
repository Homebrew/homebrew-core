class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.13.2.tar.gz"
  sha256 "8b60891f22ae22c557c539ae9debb98279d35910a7135189c300df3828a04bc0"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5d3f9d0b95be756dc7c42ab0b9892a18b3a91765b43941e40363f80fbfc1220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5763dc28a64fd8b0854ba0dbe90b0ca236b7376ad9d65e1130862500ef407128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9468a968eabb2198c3bf20cb5261d940f069a79931d0533adc379996f11b229e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfdc25d63c0de98b1edd906962060fb2bd5cd86791ad3cc1db15ba8de55782c1"
    sha256 cellar: :any,                 arm64_linux:   "f0bfabeb216f26717a16d5d170869a249a4188f6c4e43ef54f30d9b47a5d98d5"
    sha256 cellar: :any,                 x86_64_linux:  "e90d98e3ce4130b5b0424a6bcfc63d9eec86dfa77fe7f2d4c5423e5f32028b8d"
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
