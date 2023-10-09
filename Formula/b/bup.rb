class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.33.2.tar.gz"
  sha256 "d806548695c2f35be893c1eacec05a61060a1cbfe2efa4e008c44f85ee7eadd8"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0eca103fc07f6ab8fc7303014b81bcc2c48e608d8e4eb7fdb99a1b33a07c8ea9"
    sha256 cellar: :any,                 arm64_ventura:  "bb46a019407e6c7ee72bc421c5bd3ed63d35cc86af160edc2d589fbb1f775b7f"
    sha256 cellar: :any,                 arm64_monterey: "cd481ee1377e13c638c9cccfa11100e48a0bd959da4885b43c8e11d7451034d1"
    sha256 cellar: :any,                 arm64_big_sur:  "83ff925b58003d8636f0a84b04f25433ed6b5ead1228782561ce9f6e07cff34f"
    sha256 cellar: :any,                 sonoma:         "d3b3b7d232a7104778a9d03f2f55b79c44046e50d678ba9f2c6b12a3c2e72767"
    sha256 cellar: :any,                 ventura:        "565a89a883b428cc9f5cd9e7175307a950da1e9cea33fd259a75a75b60157480"
    sha256 cellar: :any,                 monterey:       "6f04f6b3b8705d984061cf1fa31a584494d54a0cba9d4931c284249d848d83b9"
    sha256 cellar: :any,                 big_sur:        "878ff99437d3ab084517ad1d1d48637e0750b2d762248a7beef53401f4ecbdc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3f8a0520a6aec3025fe0c4b75c7bc0b121cfb58c78f6adf859737d51dfabadf"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  def install
    python3 = "python3.11"
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
