class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.33.9.tar.gz"
  sha256 "310823bb3437b2a9ce8979a31951405e057fa2f387ef176b64ef3ce3041f59d0"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "988236b03242dbd381dc6831d5ef5dea6fe9983e5f1d29134e0178b0869e060c"
    sha256 cellar: :any,                 arm64_sequoia: "74c459719d6f665c6e3a98733891a40c69dafd6b3c3010b8d7ee852968b64749"
    sha256 cellar: :any,                 arm64_sonoma:  "67e4b187cd72bbf2f744bf5aac6a822c3008a8c22835a3c4f0d02a7cd34f5674"
    sha256 cellar: :any,                 sonoma:        "1363113a9ddbb8acbd4298a963cfa27d23dc2cda833d81efe1d073fc2a7265f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f827787f986ea7029b1f17aacbb360427c14d3c6d736abb1f4658d2d180f828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f913e83384e3266a82fddd3cdabca334f122459a0f2ecaa0e519b49d52a3b986"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.14"
  depends_on "readline"

  on_linux do
    depends_on "acl"
  end

  def python3
    which("python3.14")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_path_exists testpath/".bup"
  end
end
