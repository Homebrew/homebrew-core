class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://github.com/brocode/fw/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "9a8b3b1f483118597e07de9561c0fac3412b896aa950243726ef553a705561ac"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7780f59e32df0457b9148d55505e274053393a4545cf61fcf790cb0b23dfe19e"
    sha256 cellar: :any,                 arm64_sequoia: "29432219c0916cdca047dd8cccd1cd207dbc68411f0e65d2118a574f977d923b"
    sha256 cellar: :any,                 arm64_sonoma:  "93b69db1251551a66d1a24f4a9940562d2a04672ef4b19e4b39fde432365a174"
    sha256 cellar: :any,                 sonoma:        "40916ca263737c78e58fd02c91d7aa82e738fad567031cd62c0a67d7e8c4ac6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c60ab562c31623fcb540d57810708e49c38f652430c85a239b46210b5fdab21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ebff57c1fc6a7739a8486817e893a075902406d6c00ef329818f5bbbf46ad2"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "fw.1" do
    url "https://github.com/brocode/fw/releases/download/v2.21.0/fw.1"
    sha256 "2c27213d3c5dea906000ccb363ca70f167da0f67e74c243a890a935a102b3972"

    livecheck do
      formula :parent
    end
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
