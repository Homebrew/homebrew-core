class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.6",
      revision: "60846f549ccd02598dea5889992f1e4cddc8e86d"
  license "MIT"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be03936409bc31c0897e2df70b2c1387bcb7a9059ef484691bc5d8a4f68f7b18" => :catalina
    sha256 "f88ea0a7ac16b204ddc9f1a34b6cb3ad98c964b0177682e1928854e476700348" => :mojave
    sha256 "dc08b92df8eab987e5bbc012d624075cc98b63df9e7f603c12a7606d33639a74" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
