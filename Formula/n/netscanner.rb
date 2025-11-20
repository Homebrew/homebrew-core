class Netscanner < Formula
  desc "Network scanner with features like WiFi scanning, packetdump and more"
  homepage "https://github.com/Chleba/netscanner"
  url "https://github.com/Chleba/netscanner/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ad2df332bb347eac96c0a5d22e9477f9a7fe4b05d565b90009cc1c3fb598b29f"
  license "MIT"
  head "https://github.com/Chleba/netscanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b3f94976bd5b784cb146d927fe0a5f5666c6423d575a3992462d91d8ffcd228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b676da6d93f469d0818d8a36401f9ea5acaab79871be20503935313ff303aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e065a383960691a87a2e0cab684c9b96334ed59f9e6e2ee3c34bb8305fbf8c18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "457b9ebece7265aef139b9f72f3cc9304cb9da345a0d8a7598732d31c8b24900"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d8b5c71568111b671f317a4c8e1f676c2d6bce3736fe620e7e0f35b5c39ca19"
    sha256 cellar: :any_skip_relocation, ventura:       "d75f758710f6a73e9ec214a11e20c1bd3aa091c1042dd82ba16a098c57c9dc9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b62e202cf8b8f8c5fd3c700aece19d41fe4cbfe4a63a3ca499c49d98196be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9e389005e065ed119a75aeefc77f513408bcd380ba199a8b55e6e7d80a6eca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netscanner --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Requires elevated privileges for network access
    assert_match "Unable to create datalink channel", shell_output("#{bin}/netscanner 2>&1")
  end
end
