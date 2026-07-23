class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "http://miniupnp.free.fr/"
  url "https://github.com/miniupnp/miniupnp/releases/download/miniupnpc_2_3_3/miniupnpc-2.3.3.tar.gz"
  sha256 "d52a0afa614ad6c088cc9ddff1ae7d29c8c595ac5fdd321170a05f41e634bd1a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b73df945175626c5dc6c3d05061ec1718f81ed5023c24cd59fd15c569eecf0f0"
    sha256 cellar: :any,                 arm64_sequoia: "140a46fc7c4fc0b31604b74cbebbd48e741765fe51a8cce8e04ed692926dac97"
    sha256 cellar: :any,                 arm64_sonoma:  "943b48d7a7a85e18273bb25f34e177f9b75a032f3bc7f00891f6516aad64e2a1"
    sha256 cellar: :any,                 arm64_ventura: "956adafa0de14369e2e0624272c1cd6f1e777e8a359b642601a6d3933bf4bc46"
    sha256 cellar: :any,                 sonoma:        "4b03e713001a5bde4ab0e36115d3bf20e81414099361a3ee7969e98c5f6dea35"
    sha256 cellar: :any,                 ventura:       "20cf52235e1f51654b66062be1869416102ccd327769892f310fbfc74035cc28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cd223f810f0720ac35009022063a6d3f03231f97a9a17b79f0f4f86e6095160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e083d283863e771c6927a44ad88f565f0c4af7b9448a96f99af0c773d66f8e"
  end

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
