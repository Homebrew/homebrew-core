class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://github.com/boostorg/bcp"
  url "https://github.com/boostorg/boost/releases/download/boost-1.92.0/boost-1.92.0-b2-nodocs.tar.xz"
  sha256 "ea7b982002cc9dfbe59b0b217b206f470dc75f3de0bb2973d844118934d82411"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ea6b398808c21bfb0c98f87e25e6ee64a3820e947322727112696c272e86538"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4956a7bc6ec623d3cd103f32aa4e4eb0833948af9c0c2aced13cd5a10ad4e1c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d01b55c209b539665cf0e2393bc4643bc09d140b39e3c32f7365f769e6a4461d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eb9d943d97884a68344b7c41c6bd6e96b9243d1613cd5b8317728f2c5eed2b6"
    sha256 cellar: :any,                 arm64_linux:   "1700a6d4c5deff179d80d0de61162db954be82fcbdcd297ea08816987a8cf6bd"
    sha256 cellar: :any,                 x86_64_linux:  "ddbda05f62de75ff6918aa3726c299881b557010b61f1cfea91c47a97315a693"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{formula_opt_include("boost")}", "--scan", "./"
  end
end
