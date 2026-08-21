class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/refs/tags/v4.3.5b.tar.gz"
  version "4.3.5b"
  sha256 "383a17d8466cee7c1cb1d4dfbffad2651004850b29eb590e9591c7bedd46741d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4614d5a660ad58aa00e228de30c28add5dd4ee8611c0ddc5c3236a8a3941d9ef"
    sha256 cellar: :any,                 arm64_sequoia: "349f96040d93262a68f26c292a45204d1a96202b99de55f094825cb3ab520493"
    sha256 cellar: :any,                 arm64_sonoma:  "54b950c8e6d8e55a442a70b56cde596a146bd9cec7d04229a0d208233b09a971"
    sha256 cellar: :any,                 sonoma:        "a9b7105c8631b2e1786751405313d385724af7d3aaf0a9458fb348043f0f87d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8292ca619e7c69e16abb18cb5fe081aef97b1a21e2bf5bf5803fa3f9135a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e67be80f3a376965b7144640716268676dc9b2314256d41092cd9e5ba7954da3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-manpages", "--disable-doxygen", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    spawn bin/"coap-server", "-p", port.to_s
    sleep 1
    output = shell_output("#{bin}/coap-client -B 5 -m get coap://localhost:#{port}")
    assert_match "This is a test server made with libcoap", output
  end
end
