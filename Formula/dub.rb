class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.17.0.tar.gz"
  sha256 "1b5d5331223faf1320d33c0fbca48811f48893f5dcb57d5a5df8cf2ae3d845e7"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf9fce6bc8be76547f3fb0aa6fd0ac96762d13ffc6db365b1c571eaa4edaa8fe" => :mojave
    sha256 "91b64a2a139ea068832c053a97798e5adb79736a052a89732dcc950789e700f9" => :high_sierra
    sha256 "434b0862c37564e3ac7764dd92a75f7f092b373ba0792c9a628974946417a5df" => :sierra
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
