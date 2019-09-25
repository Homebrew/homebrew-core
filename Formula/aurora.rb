class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3d0f318def46f1bed3f7e16af66c2d1eddb6fdb305dd68d797d3c6cdbf99c13f" => :mojave
    sha256 "a72311fee8cf640e75bc319da7eb7c11f686620d23353d90b64852f28154d664" => :high_sierra
    sha256 "3d29b1168384d9ecf88333ea6bd25e00091904d039cf980c23d77de342350054" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    aurorapath = buildpath/"src/github.com/xuri/aurora"
    aurorapath.install buildpath.children

    cd aurorapath do
      system "go", "build", "-o", bin/"aurora"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
