class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.3.0.tar.gz"
  sha256 "670eae9df5a2bbfbcb8e4b7da4f545188993b1f2a75b1ce26038941f80dbd514"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "cd5bd13cf3635ff2ae0f476e86a3317743edef4125c56ce172bd0a16a7e810fc" => :sierra
    sha256 "cd5bd13cf3635ff2ae0f476e86a3317743edef4125c56ce172bd0a16a7e810fc" => :el_capitan
    sha256 "10a49bad80f98b27df925dbbbce2612ea0b9a1418d2dcaf1410c03175c9c4d72" => :yosemite
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version")
  end
end
