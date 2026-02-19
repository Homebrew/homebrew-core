class GoogleSparsehash < Formula
  desc "Extremely memory-efficient hash_map implementation"
  homepage "https://github.com/sparsehash/sparsehash"
  url "https://github.com/sparsehash/sparsehash/archive/refs/tags/sparsehash-2.0.4.tar.gz"
  sha256 "8cd1a95827dfd8270927894eb77f62b4087735cbede953884647f16c521c7e58"
  license "BSD-3-Clause"
  head "https://github.com/sparsehash/sparsehash.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9624c9bf9296d118481a05a3e05f9f1f8774fda3cf2d53cd63e8a4f926fd2ff0"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "check"
    system "make", "install"
  end

  test do
    resource "simple_test.cc" do
      url "https://raw.githubusercontent.com/sparsehash/sparsehash/b621b0c53615473a172aeb7fed0164a7d4df25ba/src/simple_test.cc"
      sha256 "7592cec53ea45a87d7df86e5215747666c85677a1216e701b4c9248e633c65c3"
    end
    testpath.install resource("simple_test.cc")
    inreplace "simple_test.cc", /^#include <config.h>/, "// \\0"

    system ENV.cxx, "simple_test.cc", "-o", "test"
    assert_equal "PASS", shell_output("./test").chomp
  end
end
