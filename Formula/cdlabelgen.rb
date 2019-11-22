class Cdlabelgen < Formula
  desc "CD/DVD inserts and envelopes"
  homepage "https://www.aczoom.com/tools/cdinsert/"
  url "https://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz"
  sha256 "94202a33bd6b19cc3c1cbf6a8e1779d7c72d8b3b48b96267f97d61ced4e1753f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5facce52a8f22279160a388513b2a9406f427f3ab231e119fbc0b074dc7028f9" => :catalina
    sha256 "5162ba8c34a6aeef369b5004d1608fa2b8de5a33350f1d7629f08eed8b18d5d9" => :mojave
    sha256 "ece93bae3d8b9e6e5c37b347849836dc970183efcea603d7d3b6f8f0dbaebd4a" => :high_sierra
    sha256 "a874e660972a4ac722e56e13749a17f3c76c5fa61691f44d70afb13c88e4e65f" => :sierra
    sha256 "34758541efaf3e124ff531d09cdf3f511651be8602f179de1e5ecd606b0aa60b" => :el_capitan
    sha256 "caeda225b0c542c388723e7ac464844d8924705e14313a1665526564d3bb12bc" => :yosemite
    sha256 "bf49f61ddb7f79e9699bfca3e0867b5869359be85de43184b77abadece71a645" => :mavericks
  end

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    system "#{bin}/cdlabelgen", "-c", "TestTitle", "--output-file", "testout.eps"
    File.file?("testout.eps")
  end
end
