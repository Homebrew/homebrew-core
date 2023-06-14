class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.82.0/boost-1.82.0.tar.xz"
  sha256 "fd60da30be908eff945735ac7d4d9addc7f7725b1ff6fcdcaede5262d511d21e"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546e2e4b992b227502893bb99802046bd148eac46dc70d351ac15e3a1c741fb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f66c853e71c38810c7ea1f931c0c739ab21a5f05f7eaef122f469ce676051e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "292512be6a33b38e7b5a02adb43590b8166d6c35a3a0f9f999c41949dc6fe6e0"
    sha256 cellar: :any_skip_relocation, ventura:        "de25d6bbb70a8c3601dcf42ea912a37532271684b7d7b6620a8a8125b9709c0d"
    sha256 cellar: :any_skip_relocation, monterey:       "6c284bfdabf3553242dcf2b80fc79ed6c80d61e85a5b4b6239464f003da62feb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe0266537ddf50a031ab743e22ab672adcd64889cdd2944cbafabb45a585005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a4ddd60a9968795a0fc0c961b56bbb5d97a4dfffe2daf4b1be92e7e9647cdf"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
