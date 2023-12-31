class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "76091c8d6161c73ad02f25bee26396bb6aa45422156ee7b63f46128fa8b39f18"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e857bd22e2c924556ae2b927a2c89f4b28044431b0648b14ac5010b00e1b5438"
    sha256 cellar: :any,                 arm64_ventura:  "46e697e917ffb4e3d4edb032a036d8f70bb8a067581b37ea95db7b68a1d184f7"
    sha256 cellar: :any,                 arm64_monterey: "e545e93818f6a629075ce9a5ddb7e9f82a8d6eb0794b8612ba4bf6ef190d6a86"
    sha256 cellar: :any,                 sonoma:         "257795f5af166ef1fcc49c6ec480d1ab4127504a50ba719a0715f7041b7b1ce9"
    sha256 cellar: :any,                 ventura:        "46bd33d0d92e1b8e9b594fd9363f6b3a45381f10bf5a123e6aacbf490b16dbf1"
    sha256 cellar: :any,                 monterey:       "c33d5b1fce571f69eab9adb61e4148c1dcad40907636811d507f8ae2cc5a7f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6733d090acc30425d89843fb1399840e5872001f9887c5b1617a301f5e0b5edd"
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
