class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://github.com/rahra/onioncat/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "cb830cf92e6dfefe593c941d203ee8478a9687a2708d153b0c585ad0c90ce199"
  license "GPL-3.0-only"
  head "https://github.com/rahra/onioncat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90771ab2a7452000b57fa958fe4b22f3ee9623145449a4021a64a7160ff3e5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40f981f1c2d95f993249d1716b3e6193dfad9e3731e8d7f69ede25046a0fd960"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0edf6c284d728ad4146005d49966ef7b90c347fffa2585358b3d96a724ce2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9053dd0ef8e185c7d328e3ea488106c567bf4fcff6b1b864f63ce2a0b6a882f0"
    sha256 cellar: :any_skip_relocation, catalina:       "2cc9de36de4f8fb6bf5ef7776b7e8de219444123df698ac4a9cbfc7a87f0d4e6"
    sha256 cellar: :any_skip_relocation, mojave:         "ea6c02f40094f48e34c8a4bd03d66761ddf6262745683006d58d26a27e5f5a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6032e98bbce7b3c2182c06ff794abcdcfd4ac8743d61ca367d346120c2130680"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "tor"

  # Fix missing headers remove in next release
  patch do
    url "https://github.com/rahra/onioncat/commit/daaa2efe4222910d1ee1550bfe41579cb7b480de.patch?full_index=1"
    sha256 "a4327cd9b411f7f9019106dfba7205d26f8f8249d726f5b92f0b91944a5ef238"
  end

  def install
    system "autoreconf", "-ifv"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ocat", "-i", "fncuwbiisyh6ak3i.onion" # convert keybase's address to IPv6 address format
  end
end
