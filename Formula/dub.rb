class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.11.0.tar.gz"
  sha256 "ef3f7d6ce0b726530973d9348a94fd91f9d02d30851ef3257ff538af4af571b6"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "56ba849e4a0dac3c408c063929a970cd99be20bf36593b6bdb548f31d105c12e" => :mojave
    sha256 "4681e2aad5df0c5870ee68aeaf43cc6aae4590e8bda7b62cd9d5722d5ee5838d" => :high_sierra
    sha256 "dab5e671841139054ff345ea806192db94574c21d4d776fd15763fd290c2458b" => :sierra
    sha256 "2cc454c52297644dad29ad1538e181f8d8a01c22a116990ca4836ae187c23b2e" => :el_capitan
  end

  depends_on "dmd" => :build
  depends_on "pkg-config" => :recommended

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
