class Bootterm < Formula
  desc "Simple, reliable and powerful terminal to ease connection to serial ports"
  homepage "https://github.com/wtarreau/bootterm"
  url "https://github.com/wtarreau/bootterm/archive/refs/tags/v0.5.tar.gz"
  sha256 "95cc154236655082fb60e8cdae15823e4624e108b8aead59498ac8f2263295ad"
  license "MIT"
  head "https://github.com/wtarreau/bootterm.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b2092a71f18955ebffa5397ce9350880cdade272e5010568da99ea58f2d7ec89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2a229cac60be2ea2f7c899a3b314daa4e561fa2d5a84e1b7c5e921ccec2f693b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a550becf9ccf4fec6f1de2f16834a85807328de531f45a576ee141018d1f7478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "746045840ad8efcd9aac080b0f9913635ad94db1aefba6e0582b640cd8d0a7b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81545dd801839cab947817cd04ca78c016d3543c40ceff905749186b36951d12"
    sha256 cellar: :any_skip_relocation, sonoma:         "10d45c378a0d8437c2fa3f9697c0cd9514f41bcb41c41dbb36bd3d41fa566301"
    sha256 cellar: :any_skip_relocation, ventura:        "e296d70e6c19862f037889c3f5070a8821bef0c7ea894d3a1fe78b7c5383b8ab"
    sha256 cellar: :any_skip_relocation, monterey:       "a46c3e6762cc88d3794937a95d00ab9182674980081db1702b1ea8ab994da7d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1cd346e782d0dfab70dbc82d9677d4c834088439530ac4e91bbfa30e6d28ec1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffec9a2836da5cdeecccc33cd9ce2a78fb2048121c48b07bf28b0f6317a60c23"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "port", shell_output("#{bin}/bt -l")
  end
end
