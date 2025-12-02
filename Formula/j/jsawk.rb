class Jsawk < Formula
  desc "Like awk, but for JSON, using JavaScript objects and arrays"
  homepage "https://github.com/micha/jsawk"
  url "https://github.com/micha/jsawk/archive/refs/tags/1.4.tar.gz"
  sha256 "3d38ffb4b9c6ff7f17072a12c5817ffe68bd0ab58d6182de300fc1e587d34530"
  license "BSD-3-Clause"
  head "https://github.com/micha/jsawk.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ad82c5334cd78f71f7faa8835d7c3315e0ea98f26a9a2615d8425a72d77242a5"
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
