class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.33.tar.gz"
  sha256 "2c21b25ab0ab845e1490cf20781bdb46e93b9c06f0c6df4ace760afc07a63fe9"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c16e4a2f85d1e3eebbe77b466955cf0bba468a41fa6336b4f5889cdf708c5e1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c27f726b938b0d5958310ac1c068797759d883787d50233182290704690c4e07"
    sha256 cellar: :any_skip_relocation, monterey:       "38791642448b41961ae0d08bb42b06cdafb87f61c10796886f8f8f1df5085862"
    sha256 cellar: :any_skip_relocation, big_sur:        "86326ccc67782f09e5d4d83c848c6027609a394ae2de9456d74d5d192942c023"
    sha256 cellar: :any_skip_relocation, catalina:       "0440daa882d222be41e6817735e5df52bbc8154c49623862a2f7fa1deaff8f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d458aeba96d14ee8b561d58130951dbae1fea8e69e7c131ddaa5319d01fb750"
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
