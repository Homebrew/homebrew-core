class Cvsps < Formula
  desc "Create patchset information from CVS"
  homepage "http://www.catb.org/~esr/cvsps/"
  url "http://www.catb.org/~esr/cvsps/cvsps-3.13.tar.gz"
  sha256 "5f078a6e02c394f663893751f128caf643fe00a30b559e87db6f45190c623799"

  bottle do
    cellar :any_skip_relocation
    sha256 "661a264420cedda6c6940ef81e88e91ca8d433c4c48cb79a5bb3f3d60c541974" => :mojave
    sha256 "964d2f695e15f6377f18482820f69f1efcaf305e9ea45b4bd3b6da1ad55238b8" => :high_sierra
    sha256 "fafd244bbd5ea71ef8940ec6d1d4319b6d2036c68dbafd923ed3aa1126e92c0a" => :sierra
    sha256 "166312c7b7c2aacd431120ddee3f8ca798809ee955c626cd545688c8fec5e460" => :el_capitan
    sha256 "fb968620dcdb28706f395b439fa5b2de09a5de2fec23fbb20a929234872d3978" => :yosemite
    sha256 "72af55d9573f7de107155e0a5e2160a2ef45d729e3970be27e60ecacc4baebbf" => :mavericks
  end

  depends_on "asciidoc"
  depends_on "docbook"

  def install
    # otherwise asciidoc will fail to find docbook
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "all", "cvsps.1"
    system "make", "install", "prefix=#{prefix}"
  end
end
