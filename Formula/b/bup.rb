class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.33.2.tar.gz"
  sha256 "d806548695c2f35be893c1eacec05a61060a1cbfe2efa4e008c44f85ee7eadd8"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c06dfa40708ec8158912d6a2481ce6cfa39e829396b063f7c9569df6e6829dad"
    sha256 cellar: :any,                 arm64_ventura:  "755c4ac3f23e711c306b88bd5b03cdcfab1e73e41c90d9a6685d79dab634fd2b"
    sha256 cellar: :any,                 arm64_monterey: "49effff9f3e42a0792da444b5c77443f76427e468c7a5bfe590d6e55763a82f4"
    sha256 cellar: :any,                 sonoma:         "1c547df49d99f8236584da0e156d3d67f18b0e591cc7ac51804d1c978aeba2ab"
    sha256 cellar: :any,                 ventura:        "96bf06e4122558f11037fe1440f379281a95481167b00dc107cfc0d16dc22214"
    sha256 cellar: :any,                 monterey:       "e8c288adf042f124d177e962666c338a9bed36d1b15bc84971ccccae4de87fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82cac0e032e3274d89d678c1d339fe90b4a43d805d16a120579d41855dd29de7"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
