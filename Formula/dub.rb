class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.14.0.tar.gz"
  sha256 "47c463eeaa612fda556d0291d32c8c59fd3c31dbb76142c7d997b7476773c332"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bfd8f4b0b41d85ab45c1c7b891b4bbdab7b1221c1af9b7b6f0374bb2d2511c3" => :mojave
    sha256 "ab6fb42a418e648c195971ee2037da783fd9c41eedf57ac8b13c3861563b2a97" => :high_sierra
    sha256 "5ad4d0b09bcf6acbf52771683d9aa5b3e0cf355d8c59707a6bd670f9491bf875" => :sierra
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
