class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.21.2",
      revision: "e5605ee2b76161ddd99a0113f3865d523acb8bde"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbbb54652a57cf74add0db7fa5cb8627c79b37997783eb65ab5182b25f030a48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5170ccae1c3a532210d7df6d6503f38f778ae0d39c3a3b52e273d4978fab138f"
    sha256 cellar: :any_skip_relocation, monterey:       "94641bad4d7a62169b7d4a3381a0ecd9384ceeb94509b6403d3f8afd29e0bdaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7663b9433be0efb68ba1abac902f08bf8760c3ee2551f6abc7ab8791e999ffc"
    sha256 cellar: :any_skip_relocation, catalina:       "5a99c5999e61d1cf2b511142c2187d42e98c5d36223e3137d948a40468004707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8b8cb76151c9cf4857f5735c3e3695f7002f726fb3f199de6143d8c3b12447"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
