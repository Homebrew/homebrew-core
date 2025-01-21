class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "3dca77bf459b34ac92e8a6c84b90e95aa9684e09044c4743b66ac427acb49294"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7487d8b5a79bea6c9bb223f71cfd58270dbafec545c885f8c40e2cf323fd7e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5825f6dedb4729b63881c086d43698bdf99505e9710fe91ae40e9006b4d1058c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6994ab3df041f72ccce5ae31740db50ec413e09971dd8dabbf944dae035f4cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "703c435af047d0df001a82f6b2abdd923ea05d397d66959a4d468f7137fa4ea1"
    sha256 cellar: :any_skip_relocation, ventura:       "d4e6137b141d511884ee415d3f716df086df24317f6f66ca5d63e1fe0ce0a629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "703f91f3bf72b3987cef92fa1a613b051a7246d9fd55b1eff5d3b8f1b937867d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}/cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}/cotp --version")
  end
end
