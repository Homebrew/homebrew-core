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
    sha256 cellar: :any,                 arm64_tahoe:   "cd14056e2a81b11fd288c68433e1f87005671ca829fd51e56de976b672a598db"
    sha256 cellar: :any,                 arm64_sequoia: "eb202098914bbc6a57f1934081506e50fccd9ee67ee37b9ef91b2b2484976f7b"
    sha256 cellar: :any,                 arm64_sonoma:  "b99fcb8532b6b7bc74ca0a292e56587a9965c4a01027b556ff1d508637490f11"
    sha256 cellar: :any,                 arm64_ventura: "75b0b011571ecad44d356a4faef9a567b6c5bb0ba21902bf6ac8fbd4a482e505"
    sha256 cellar: :any,                 sonoma:        "70ae18ac9fba06db184692a0ae3cf8572968a3551315371a7d0bb720f3f900e3"
    sha256 cellar: :any,                 ventura:       "5cbef520c888d19d9a8e0371ff1a6c3df79ad7e9feed67eff8e9f387da2e18de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1fc07bfe852cd4530592303da3b6918413467777ae9f9becc6845a1113ab94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37b9bd2e6018551c47b3c0774add1b88594f21a608b0a801c3a2154d28a006ed"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
