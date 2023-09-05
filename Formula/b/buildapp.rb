class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/xach/buildapp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "468c2887f5a309815e85988bcfca8eef8764c3f5055572e342da83ee3409c7c4"
    sha256 arm64_monterey: "d2b5001a28d69d60a31214ddb65e0a4a10b240d4ff80168e1e7606cc9bd7bce8"
    sha256 arm64_big_sur:  "55b809a69e52c8adcc143bdbc4bad1e4f0a478c1a7861abc2801cbf44584ddad"
    sha256 ventura:        "4655e54b740f13f6e3c29ef8fc242586b5e98e8d548dff8b3a2300256b5487bf"
    sha256 monterey:       "f431518369e379b761850cc758a05a24c8192a48bd5a67c4ed165622910c1c46"
    sha256 big_sur:        "60a961473709c72ba66996bb99f3d0385d220eab7c3c833b603fd6a8b93bceaf"
  end

  depends_on "sbcl"

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    code = "(defun f (a) (declare (ignore a)) (write-line \"Hello, homebrew\"))"
    system "#{bin}/buildapp", "--eval", code,
                              "--entry", "f",
                              "--output", "t"
    assert_equal `./t`, "Hello, homebrew\n"
  end
end
