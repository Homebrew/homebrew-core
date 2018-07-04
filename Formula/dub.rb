class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.10.0.tar.gz"
  sha256 "db6c3a9e45408d2431bc3d1138a31b561fb71665c1d89db4b0cb3725b2b12faa"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "d2793e9348aa4acd0d9a5ce4497e8e5d8233809a2e7656e4f15f3bf3a6618d1d" => :high_sierra
    sha256 "a69c553d1148894029ee83a7a642b3774bd27860b49a07188b93e2ca7b58f7fd" => :sierra
    sha256 "e50dadec35b96a9ef9791ae670b482cb9ab3cc293c249aeab575ad4ce38db304" => :el_capitan
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
