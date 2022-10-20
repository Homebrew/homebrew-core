class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.33.tar.gz"
  sha256 "2c21b25ab0ab845e1490cf20781bdb46e93b9c06f0c6df4ace760afc07a63fe9"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30fea55aee5ef824fc704b84c5e8c4f93f3c0659b80d5b21968e8f977cf11d11"
    sha256 cellar: :any,                 arm64_big_sur:  "5c26068d9d30ef24aac0c293e897df200dcf4b75d31439cf45563f369865ba75"
    sha256 cellar: :any,                 monterey:       "87dc510d47ccff7cbd245839caa0e445a038419759632af893b2f11824013ac1"
    sha256 cellar: :any,                 big_sur:        "d0d55291ad9815b362674a2bf8da9f220d92f06a2c1d4ca6a9928d4fc8cba5ca"
    sha256 cellar: :any,                 catalina:       "d71822befd146bc23771153936214ada6c68153fb0a03c741aa92897a033f496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2b04f72abe281c2a990f758c3b8253f35dd417bb37b5e200028e3a9a8145494"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3.10"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
