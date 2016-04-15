class Premake < Formula
  desc "Powerfully simple build configuration"
  homepage "http://industriousone.com/premake"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.3/premake-4.3-src.zip"
  sha256 "36536490f8928d8ecde135da80cd8b751ea5bebe50cabba5c0de49cd41cb2780"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "02f55d278bd04f5e1ebf779e9a45921ea476fdb48e56ac52f0a71cbef541bc39" => :el_capitan
    sha256 "71c9f710b6c595054a2bc27c484b2ec684a9a14ffe5771112891e2a5226b4cbf" => :yosemite
    sha256 "b67d28d0978c30da8d3988b289772e2f0f6dd0b5ea21bd8bce4049cfca095b46" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
    sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  end

  def install
    unless build.devel?
      # Linking against stdc++-static causes a library not found error on 10.7
      inreplace "build/gmake.macosx/Premake4.make", "-lstdc++-static ", ""
    end
    system "make", "-C", "build/gmake.macosx"

    # Premake has no install target, but its just a single file that is needed
    bin.install "bin/release/premake4"
  end
end
