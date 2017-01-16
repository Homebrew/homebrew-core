class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub/archive/v1.1.2.tar.gz"
  sha256 "2945c8ab52a421da3ae4c64cc655e3322bd01a9a15ef1ea0208ec999d0e36b91"

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "7827c87c92d9f4e172188bc7b85aaf7b2ac91b550c38835bc9540fc77b6d157d" => :sierra
    sha256 "7827c87c92d9f4e172188bc7b85aaf7b2ac91b550c38835bc9540fc77b6d157d" => :el_capitan
    sha256 "b82248608a872053d4af56720647fc14ea382345f5a09bead56205b34b7fe56f" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.2.0-beta.2.tar.gz"
    sha256 "d319620d17fcc9d8c43cc2f958ff3147b0d36aac8f5c62200af5e56960404cff"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
