class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.16.0.tar.gz"
  sha256 "f4291dc053864b81c10dc1e9f9220aee3d4ce7ef735ecdb70de9ecbf6e0aaa5b"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eddccf9556c63b19f6997546ef23866493c688b9e50963675edb99ce3a44925" => :mojave
    sha256 "ad244aa4cee496a5aaabbe41e1cdfefa09893a0be68c56440cc1fc44f716fbb0" => :high_sierra
    sha256 "201b46005d942fe5b995a452eecd87b0032da24f7594fc838ade493261d26d5d" => :sierra
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"
  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
