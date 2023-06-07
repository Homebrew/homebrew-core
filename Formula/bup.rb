class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.33.1.tar.gz"
  sha256 "b459f517949ba7cb7c9810f06d0ed50cde0f4070a9d2e4d78ac318e21a29c690"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86ba4e56f6b6a997177a42f9fe996709d0e9cce75bc690e7d7cbb7cf44ab82fc"
    sha256 cellar: :any,                 arm64_monterey: "9a6e835ab7a892188c7c0d421a32d7ba49bf173ae35ac5c06be8039e751620e1"
    sha256 cellar: :any,                 arm64_big_sur:  "64386aa60a621da49862aec6e88829ec5c5ee7b96dc35b4b16ad323ad22df69d"
    sha256 cellar: :any,                 ventura:        "7727ad7ad49b2e1d33d335490e6727e3ba5dc19203239fc3e0d503b7826b3c88"
    sha256 cellar: :any,                 monterey:       "425107d25c4825a710d88f8db57655c4600161e8253dda8ccd859c341f08d870"
    sha256 cellar: :any,                 big_sur:        "d7d59ac2746bd000bd1fd1ff59501946f659079e859ccdf2a02d2ebc2c74bafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fbc7b8c30955111048b9b8e32af5b1608d0790bf47bf187e90152f9fac62d83"
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
