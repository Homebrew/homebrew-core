class Jsawk < Formula
  desc "Like awk, but for JSON, using JavaScript objects and arrays"
  homepage "https://github.com/micha/jsawk"
  url "https://github.com/micha/jsawk/archive/1.4.tar.gz"
  sha256 "3d38ffb4b9c6ff7f17072a12c5817ffe68bd0ab58d6182de300fc1e587d34530"
  license "BSD-3-Clause"
  head "https://github.com/micha/jsawk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e99db0c7e694b8d1171c5ea012d12442f708b8a2808ae136cc38b63309f71899"
  end

  depends_on "spidermonkey"

  def install
    bin.install "jsawk"
  end

  test do
    cmd = %Q(#{bin}/jsawk 'this.a = "foo"')
    assert_equal %Q({"a":"foo"}\n), pipe_output(cmd, "{}")
  end
end
