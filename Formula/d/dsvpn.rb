class Dsvpn < Formula
  desc "Dead Simple VPN"
  homepage "https://github.com/jedisct1/dsvpn"
  url "https://github.com/jedisct1/dsvpn/archive/refs/tags/0.1.4.tar.gz"
  sha256 "b98604e1ca2ffa7a909bf07ca7cf0597e3baa73c116fbd257f93a4249ac9c0c5"
  license "MIT"
  head "https://github.com/jedisct1/dsvpn.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "88af31d52cccd25f31de08063e945c74ff83ebdc13e9bfc5cdd1c25a760d83d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2798e3025b267d17e1aabee53f9340abd9f38327278913165a305a4749d87dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0c26df1e9f03e517ac0db4f266b348cdd95104a250c4da9f7acbb6c73341d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "889d8f51fbe721906b84001adfcced14178739901beead09b88977a8b194c97f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "533ca096976136d7eeb0923c0164a0b3e8305d344036c1ad095a586f8768f5a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f0269b49b371b7330a7397c73ca1a8791da2e1215242eacd3e612f6705dd9c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "acee3cf137a18f22b9063c71426ee83f91482e37077a5c343ff465c142537619"
    sha256 cellar: :any_skip_relocation, ventura:        "bf4216d9f7d920dd9c3addf7c946ee730f74e2fdb361ea76e835855106a97ba1"
    sha256 cellar: :any_skip_relocation, monterey:       "aaedaf19c0e6217233075e082167848fb03b2b2e3d3f27e690ac8f82064647f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9113686d8da5885ab67bae686914b0d27cc5eb2588a49b83f7c3fe66c89c039b"
    sha256 cellar: :any_skip_relocation, catalina:       "a08464eca0167991c580594ecd9f1893a7be6d1cb522ceb385ff1883dca507c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "245403f9b3b33e4b63fc2281f1ffc16cedc3d48e825691369d755a22b61a24ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6cc8aa7ec1d462fb028d5858de3863d2d131175ddfa102cfd44c9c0614d003f"
  end

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
