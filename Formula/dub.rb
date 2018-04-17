class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.8.1.tar.gz"
  sha256 "79ad2dca0679f6d8b6a4d75e7ccea7930957134743bba290c949d5aa1aa53a14"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "7484306cfaba14aff965a6a32ab47d194592ea8ae6720f617b545de586db3785" => :high_sierra
    sha256 "309c7a42cdf6b1eda8dfc8c3500c51ece625be157ee9ee6233b75655f9a14413" => :sierra
    sha256 "0f12587d134ada1588db6f6f228f8ff679101c0c53db4715bdb93a03292b65da" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.9.0-beta.1.tar.gz"
    sha256 "505729f13eb14845d0faf4665ae69f93430c49c03f4d67541a32052b98794c71"
  end

  depends_on "pkg-config" => :recommended
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
