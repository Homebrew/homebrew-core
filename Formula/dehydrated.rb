class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/lukas2511/dehydrated/archive/v0.7.0.tar.gz"
  sha256 "1c5f12c2e57e64b1762803f82f0f7e767a72e65a6ce68e4d1ec197e61b9dc4f9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "524986e082bbd4c8e7ea0ac7ae5c8bc8994a1db2dfeb814905422c0b197107b6" => :big_sur
    sha256 "844e6e0618f99e44fb74c86abfed902f82e6c67ac9879f41a1f1bd0922554730" => :catalina
    sha256 "376b14fa1047117a1779c583cd73139b7e4e8d3dafae240bac62912580aae571" => :mojave
    sha256 "376b14fa1047117a1779c583cd73139b7e4e8d3dafae240bac62912580aae571" => :high_sierra
    sha256 "1b4042e46b66cb78a1f4a423d742bfe3110f12ea8d26177ff0f05d2aea24d6b2" => :sierra
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/lukas2511/dehydrated").install buildpath.children
    cd "src/github.com/lukas2511/dehydrated" do
      bin.install "dehydrated"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
