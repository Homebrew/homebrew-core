class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.11.0/fswatch-1.11.0.tar.gz"
  sha256 "9ad5fc35f835d37445dd4bc87738c5824d98c1ed564d0491b0a6625073b6c128"

  bottle do
    cellar :any
    sha256 "c9f0c406fe6de43548579a14dea3dabe4a9d8b79866a8257f4ac8b9b7be13b83" => :high_sierra
    sha256 "9aa56eadde3e8fe4f7164d96820b5caff1477e47d45679ca500066f592579596" => :sierra
    sha256 "b244fd87527e532e68ad15105976054039d2ca069b7aa5de4b1d25a38baa88df" => :el_capitan
    sha256 "a65c53d70582be908c908c30479053b4688e27a87b35cb0c66e86bd2e6751024" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
