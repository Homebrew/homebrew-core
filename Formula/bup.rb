class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.33.tar.gz"
  sha256 "2c21b25ab0ab845e1490cf20781bdb46e93b9c06f0c6df4ace760afc07a63fe9"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "fa27d1e7d41e432cd8e92a4bef4a0f40baec7aa017409bca0afbaea7600ae837"
    sha256 cellar: :any,                 arm64_big_sur:  "c4ecfafadc9a7a307b0e0b1d3affadd69a96307ba577abd257d7819d19780916"
    sha256 cellar: :any,                 ventura:        "5a22f269e8ab196be9724bfa63adfac2596178a50cc65bcb06a4f916f35c87de"
    sha256 cellar: :any,                 monterey:       "8f3aafa9e04c8ae9948e636212512b21b9ef56ed7a98d7ac7fa2a81de9c57ec8"
    sha256 cellar: :any,                 big_sur:        "949abf70c0e25dfc73f42ee8cf3d8a5fde1451f1ee1a3c0751857cd63bbd5e10"
    sha256 cellar: :any,                 catalina:       "f3a2efd0a2b4c434677b736a0f59e5dc2be8fbd9352c90e7a818ff78af60d9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76efebc4d38d833aaf7b0d9052ea73191b2d6deff579fe64bb5b25e9d246d27a"
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
