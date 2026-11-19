class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "http://miniupnp.free.fr/"
  url "https://github.com/miniupnp/miniupnp/releases/download/miniupnpc_2_3_5/miniupnpc-2.3.5.tar.gz"
  sha256 "b9a1e57233216c5f62572de6d628e73e910f50cdb71e9c0eb89b169ce154d256"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/miniupnp/miniupnp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^miniupnpc[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d7e9b9f0e5f0a30040ab7181f97e04644db48b378c717c88cee30e7ce1872bd"
    sha256 cellar: :any, arm64_tahoe:       "159eb8471db7c3375b6670364111bcc21ad10f92d53b57eac77b0bb29ed6099f"
    sha256 cellar: :any, arm64_sequoia:     "0d558e5433fcfdd53179c65082a62ba42abaa55b6589f76bb553e3927e6fba42"
    sha256 cellar: :any, arm64_linux:       "1ba898dfa2c2a94ef77b0f6aac40f6ca87c7441fcaa269504681e04c3a2f8f89"
    sha256 cellar: :any, x86_64_linux:      "51522e207314a8b2de82aeec4d4d929328247436c49aea8b28497233d7900fe1"
  end

  deny_network_access!

  def install
    # When building from head we have to cd into the miniupnpc directory
    build_dir = build.head? ? "miniupnpc" : "."

    system "make", "-C", build_dir, "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    # `No IGD UPnP Device` on CI
    output = shell_output("#{bin}/upnpc -l 2>&1", 1)
    assert_match "No IGD UPnP Device found on the network !", output

    output = shell_output("#{bin}/upnpc --help 2>&1")
    assert_match version.to_s, output
  end
end
