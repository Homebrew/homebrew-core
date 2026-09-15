class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "a6a3c2f3bb7e5a8597f507bcde1abd898020a53b9b169e8df3b53cc2eed6e60f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55bd986a6403e8159caf5097857eb1d14edcab89ce2b14920f30bcc83d28075b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09836f566e0699cd06e08a5630990bff3ae551f1c5a892e889319926134f03f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85a6e3504fae4ff2ec3236e5956567190878e71c96067d1c7a7c42e2aa447d80"
    sha256 cellar: :any,                 arm64_linux:       "7af5407574b2ceb765796b12cd805cc0277d36d5f60c0fad6be795e7fd0d1db8"
    sha256 cellar: :any,                 x86_64_linux:      "8046070774138809fe4dba3ae2ed1f7671fa47bcc635302eccfefe7ef8a2372d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
