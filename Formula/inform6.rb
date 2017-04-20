class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "http://www.inform-fiction.org/inform6.html"
  head "https://github.com/DavidGriffith/inform6unix.git"

  stable do
    url "http://www.ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.33-6.12.1.tar.gz"
    version "6.33-6.12.1"
    sha256 "9170d6a0283aa65e1205621e89f78d674c8df978ee9c0b1c67f8b1aea4722a77"
  end

  bottle do
    sha256 "9ba31815431daff2d34c193bc48acaeb7d97cf312162efd809a28ea53c0e3e04" => :sierra
    sha256 "7907b51b7c5b95d258a0418e6c8a455b814266ca72498d28573b9021761a57e2" => :el_capitan
    sha256 "517cb99fc16eb03a54deb203c90c891982d6bbcaa1a135dfec4f8b4bb79029ab" => :yosemite
  end

  resource "Adventureland.inf" do
    url "http://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert File.exist? "Adventureland.z5"
    end
  end
end
