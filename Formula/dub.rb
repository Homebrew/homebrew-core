class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.7.1.tar.gz"
  sha256 "baa8c533f59d83f74e89c06f5ec7e52daf3becb227c7177a9eeab7159ba86dbc"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "1ca19d9eb7c871a9e53e3d09c2d2bad8da41b20e4cb6f91041d034300840a6b6" => :high_sierra
    sha256 "d6df5aca7ffc58b4820dbd9c896d89aeeaa86624c348fc6af9b7018393c7b368" => :sierra
    sha256 "7a80d992855844a0c7ee7366f0065a0aac0a89fdd453e113903a7126a0363f2e" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.7.2-beta.1.tar.gz"
    sha256 "5f1f9a4f59bee5721b7e6f49a87c49732908743f0c0f30b31a746fca26b16489"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
