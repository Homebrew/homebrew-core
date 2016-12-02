class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub/archive/v1.1.1.tar.gz"
  sha256 "9931c03fa908e83632553572bdcfb3570b8175a57b00b9ff7c9b69b991662b89"

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "7827c87c92d9f4e172188bc7b85aaf7b2ac91b550c38835bc9540fc77b6d157d" => :sierra
    sha256 "7827c87c92d9f4e172188bc7b85aaf7b2ac91b550c38835bc9540fc77b6d157d" => :el_capitan
    sha256 "b82248608a872053d4af56720647fc14ea382345f5a09bead56205b34b7fe56f" => :yosemite
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
