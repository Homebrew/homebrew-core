class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.4.1.tar.gz"
  sha256 "56f99f06fb1fde0c0f5d92261032fca1eeba1e23d224b614da9fffbcb22ef442"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "2cde0af323c7ecb5376f3b0615c44451f2f97d4c5856b2e1252599f4f3f81902" => :sierra
    sha256 "64f01c4b8fdfc75d298af9b65e256b3600c87370ec8b6d05a3f28b2220f84be1" => :el_capitan
    sha256 "a6fd6a055aaa21fe63b5fb7203d825922d12304e35ba11fea8794987b8688a62" => :yosemite
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
