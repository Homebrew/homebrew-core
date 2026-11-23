class Dsvpn < Formula
  desc "Dead Simple VPN"
  homepage "https://github.com/jedisct1/dsvpn"
  url "https://github.com/jedisct1/dsvpn/archive/refs/tags/1.0.0.tar.gz"
  sha256 "fd1b1e2cd95745af54e3cfd62825ce73a5e1223de84cd7abc170401e89eee0ff"
  license "MIT"
  head "https://github.com/jedisct1/dsvpn.git", branch: "master"

  bottle do
    manifest_sha256 "e6435de2157994f75d7b0ddafef76ad0e4d46774fab59f83278b51bb0adb45c2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bdead0d792944c4091c52da07dec149d6189133c7ae4d275c4179554560a71c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b639ed6155a97b325bf530ec77651837cc76e67bc31d0a5140264322ecb419de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd69e59e85352804e32aa226e4e4dc479f70c7ec857e44399d603630437a0873"
    sha256 cellar: :any,                 arm64_linux:       "5440fe53e23864117663027f8925cbdf7ae39ba3bbd9841c160a23a0fc647edb"
    sha256 cellar: :any,                 x86_64_linux:      "224ce2cf51e17c1eb1e09562b2ef96e8aac684bd03203c887c06f54c0bff6dcc"
  end

  deny_network_access!

  def install
    sbin.mkpath
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      dsvpn requires root privileges so you will need to run `sudo #{HOMEBREW_PREFIX}/sbin/dsvpn`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "tun device creation: Operation not permitted"
    else
      "Unable to automatically determine the gateway IP"
    end
    assert_match expected, shell_output("#{sbin}/dsvpn client /dev/zero 127.0.0.1 0 2>&1", 1)
  end
end
