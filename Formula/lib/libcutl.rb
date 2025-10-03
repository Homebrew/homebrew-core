class Libcutl < Formula
  desc "C++ utility library"
  homepage "https://www.codesynthesis.com/projects/libcutl/"
  url "https://www.codesynthesis.com/download/xsd/4.2/libcutl-1.11.0.tar.gz"
  sha256 "bb78ff87d6cb1a2544543ffe7941f0aeb8f9dcaf7dd46e9acef3e032ed7881dc"
  license "MIT"
  head "https://git.codesynthesis.com/libcutl/libcutl.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "28208d61e906d8696553ebd1b65a0d5c2abb8e889c91bed188f8bb434a112977"
    sha256 cellar: :any,                 arm64_sequoia: "085cbb14470957513c5a48765d1f0f924cd6646b7cb6e5070863b3fe756f54d2"
    sha256 cellar: :any,                 arm64_sonoma:  "e20cc790ca579e8ae7ab5f69774ad67bd58f1eb6343f1fd87db494beb7cfb3ba"
    sha256 cellar: :any,                 arm64_ventura: "bb7b24cba44acb490f955c4961d91bca0f8d32cef0fbd789288d267965f87df7"
    sha256 cellar: :any,                 sonoma:        "a392b127303ec453757aa05d8cae2dbac76dba151c4b443a292fbbf87f49ee53"
    sha256 cellar: :any,                 ventura:       "f3aabe420e6e8761a2b0ba98be18baed7d109ab1322a607372c774127ac7bc74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "581f7b0d2ce59b1b8c006e97a0dd4724542b9842add5c14fbc09546d7b53239f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f825e2f1b6e5e519c80bc8de1fcd0f65def78498b5c9c07e7f6acf436081ac"
  end

  depends_on "build2" => :build

  def install
    system "b", "configure", "config.install.root=#{prefix}"
    system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"
    pkgshare.install "tests/re/driver.cxx" => "test.cxx"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"test.cxx", "-o", "test", "-L#{lib}", "-lcutl"
    system "./test"
  end
end
