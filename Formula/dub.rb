class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.19.0.tar.gz"
  sha256 "84dc77f517ca1f115e05e25e8a8cdbcacbf31df281217ebac31dc974560a4ffc"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cebf3a1f606c69d667c5c4214fcadb9b64e2222bb83cfff946c4e8df81e8f0e2" => :mojave
    sha256 "48fe0094c432bbf312f12c3fbf4d73214a41b4a0cdaff8ef7c140d67bf20c133" => :high_sierra
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
