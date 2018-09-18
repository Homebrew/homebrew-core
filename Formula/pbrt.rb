class Pbrt < Formula
  desc "Physically based rendering"
  homepage "https://pbrt.org/"
  url "https://github.com/mmp/pbrt-v2/archive/2.0.342.tar.gz"
  sha256 "397941435d4b217cd4a4adaca12ab6add9a960d46984972f259789d1462fb6d5"
  revision 1

  bottle do
    cellar :any
    sha256 "bbef8afbd930c10498a65d8e70621eba607489a97994ba1b875523eec2db8b88" => :mojave
    sha256 "c1914092491b0a3e9b8f0aa53c08c290e4548d4c8236652f6987f585506c840b" => :high_sierra
    sha256 "e55782038c1b74d847254afae36fbfe11d3af774431b84bd7d56f16bbe73986b" => :sierra
    sha256 "f9104d3cf2dc87dc5b8cdc6b43b7c32447508ad4282d4caa850136e9742b61be" => :el_capitan
  end

  depends_on "flex"
  depends_on "openexr"

  def install
    system "make", "-C", "src"
    prefix.install "src/bin"
  end

  test do
    system "#{bin}/pbrt", "--version"
  end
end
