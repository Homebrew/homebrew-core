class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.2.tar.gz"
  sha256 "6487b89afa5f2b57d6905cdb45b5e596eb18ed0081f311f6a260324b460f610a"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "e154102b9495451c0d451ebcd6ac7de6f5baf46274cf7a36ec468166e249b8ac" => :sierra
    sha256 "e154102b9495451c0d451ebcd6ac7de6f5baf46274cf7a36ec468166e249b8ac" => :el_capitan
    sha256 "fdc6753ba4c44dc2cbe6ac04217603c86e91b2f2e2018491d6afe94bcd61560e" => :yosemite
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
