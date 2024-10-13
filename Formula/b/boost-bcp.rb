class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.86.0/boost-1.86.0-b2-nodocs.tar.xz"
  sha256 "a4d99d032ab74c9c5e76eddcecc4489134282245fffa7e079c5804b92b45f51d"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ffb4008bbb45e46d39d79e533b2e68c91265eaa2d8218e1f952d9a23c8591b38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71a91245121f77c99012d380f9db16547258ef90929f8379e5366e21c1cc0920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8801fa7e542ae32193d6db7a56a2ec332e661cc5e54b384aaf522a6ccfcce7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6489e88b9108c0c565527c449459f8fda3304bed9cebbd0494a9737b159c9691"
    sha256 cellar: :any_skip_relocation, sonoma:         "89b15fb9b2e302f3cdd3ad8d2cd42a0328e2d3c3b3d8aa4cb7c64714261d5a11"
    sha256 cellar: :any_skip_relocation, ventura:        "64761f365fa1c066ce8956b11175b387a7d0c82bb0b7dee27dc94e5bae631da0"
    sha256 cellar: :any_skip_relocation, monterey:       "89c417afec94024fd40f7cce718a27e5f244c6ade1dbede09debf636febefb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e90a611b39ad4f37d14c034e64be56003fb27ab4de249c9ce7d1897503a892"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  # Fix build with latest boost::filesystem by applying commit from open PR
  # PR ref: https://github.com/boostorg/bcp/pull/18
  patch do
    url "https://github.com/boostorg/bcp/commit/cd21e9b4a749a77c24facf2da44f01e032c40842.patch?full_index=1"
    sha256 "09fdccb8ebdef5d13bbccbeb48eec7d14bb6916c75ea5c14fc439ff2bbd0f080"
    directory "tools/bcp"
  end
  patch do
    url "https://github.com/boostorg/bcp/commit/c98516b5b76e9132eba78a399af9c95ec8d23bd4.patch?full_index=1"
    sha256 "557221988cda08f5183310c5ef50fdef79e4c096c8e849cd42f170c802ba7b6a"
    directory "tools/bcp"
  end

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
