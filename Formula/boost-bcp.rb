class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.bz2"
  sha256 "1e19565d82e43bc59209a168f5ac899d3ba471d55c7610c677d4ccf2c9c500c0"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d023fa0cac69acf6f984490010af42aed546f6bf882efb21b91ff3ee7bed18ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22f911d13db37f9f87c516cada4cf41b9dfaea7dfd8dd948baba5dda2b1e625e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6a9e8880cf68faec11e18b96028043442b8fda1064049def70e6861bedf1b82"
    sha256 cellar: :any_skip_relocation, ventura:        "a0a5d6c58ad208d5587a97aea1a6d074185a6f23785989c43c4d78d1095f9068"
    sha256 cellar: :any_skip_relocation, monterey:       "6b01167eaa34dbe8b4736aed2f8b6a49e714c381e9d616d94d17afa48dcda6c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0d714042b682b610a45519572a95086fdafda8b99973bed9f1761c4fd86b824"
    sha256 cellar: :any_skip_relocation, catalina:       "6b3a2bb31ab835dd1c6803b163655d4f316def336cca9ad17dc49ea5d7344b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ab8de62c6d48d64bee4c41355789c68b5ace4560df58cc3650b3a1e6bfe943"
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
