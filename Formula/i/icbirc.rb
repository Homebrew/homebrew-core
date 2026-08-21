class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "https://www.benzedrine.ch/icbirc.html"
  url "https://www.benzedrine.ch/icbirc-2.2.tar.gz"
  sha256 "de045b4fc826abc348d4f83ac674a135faeee7235a4941d5daf35e85a83c2b3e"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?icbirc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c998f5270b13a3a5db9e45e5de4caa5be03068f0d4a2aaa01de14a2269cf696c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4246015b1c291cb3a55226ca562a4af17b4898367b94995842d093d39f679c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f5a69f48564c553cec8b3239d2d85b06799d3a92ff590bea143a4a52041a4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbc895f1f9d189f480b198d6b21cfb19058ad162640c26563370fdca83d4d3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2f06c70f2aa742d48a0131f67f2c3c1036699888f536d3fa4c05200a5b02de2"
    sha256 cellar: :any_skip_relocation, ventura:       "8ac135755acfc32dcabbd12e8a0deb9fae1f8b02ca9835c1fbdf567121214de5"
  end

  depends_on "bmake" => :build
  depends_on :macos # needs strlcpy and Linux headers aren't included

  def install
    system "bmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
