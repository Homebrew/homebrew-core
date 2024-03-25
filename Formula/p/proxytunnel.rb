class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "edb33a74ba49e745b55b790f123366c8336729947225f4b5d816f1f90551ecfe"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ffbccaeaeb8b13ae2a6997da07038135ee510beb2554c35a85e0778fdee2105"
    sha256 cellar: :any,                 arm64_ventura:  "a3f207577566a342127f43680a15d020cc16c548115c3dba2b66aa30be4e21d0"
    sha256 cellar: :any,                 arm64_monterey: "b0592b8359a5d378efeb291b4122c42e76637cbb2a58afaa823162852e1da68d"
    sha256 cellar: :any,                 sonoma:         "bbbe1b70632817a039559a2661900c6c60cc9a808e03f265eab1f3aa883173d7"
    sha256 cellar: :any,                 ventura:        "bcd1893aadace3a539c8bb47cfaad53ff53af18018a076645b1b0aa4fd0f5278"
    sha256 cellar: :any,                 monterey:       "701e72553a25dedb0d38390c1880092719ee803be183f90683f44dcdf674bcc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e30dc784de8bdbd892a57dbc18c9d54fc33c9aa569803c9ffc070ea5d00844"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/proxytunnel", "--version"
  end
end
