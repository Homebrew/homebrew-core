class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub.git",
      :tag => "v1.0.0",
      :revision => "b59af2b8befb4fad4157d8c9cc86dba707b2fc87"

  head "https://github.com/dlang/dub.git", :shallow => false

  bottle do
    sha256 "51a032793dc4671d6c12172ef29c38c98998dcd4b6aa501be2a5d35248b27244" => :el_capitan
    sha256 "d438a6fde4094513dd9f5ea30a7aa672e7dc6b764033fd4405adfb37861e49ad" => :yosemite
    sha256 "5bab5095000421e561fbf41268c615e079023b86a0d6d7ed00328ab52a7db906" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
