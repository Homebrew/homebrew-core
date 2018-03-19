class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.8.0.tar.gz"
  sha256 "acffbdee967a20aba2c08d2a9de6a8b23b8fb5a703eece684781758db2831d50"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "55d6329cc5b3ff35a86afe1fe2dd344028f5720368b2352a1f31e0cf223d2ee2" => :high_sierra
    sha256 "29dff693089f35e3c09022b79ae153dbaf8457087b528d56ae0ac10feccd9024" => :sierra
    sha256 "43959b85a6cb66c18d4835eca8dc3183fa1cd80af3f71dc90f38b3ed54b30038" => :el_capitan
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
