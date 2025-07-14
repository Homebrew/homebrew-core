class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.33.7.tar.gz"
  sha256 "03bf3c02ee6912d9f2e017e488625948818efc8538bbc6a7d6a993fbdee709a4"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "190deba7059ec4e0fabef2a19d2e505538f19d72c8e7b0b7e19c640d02cc07b4"
    sha256 cellar: :any,                 arm64_sonoma:  "7c0fcc1869f7bbbd04817e038c93bf112343e2c350899eb42e5c7f1cb76a1738"
    sha256 cellar: :any,                 arm64_ventura: "bf776628703118c1778d0d65a7e63d916afd13db57645d65747933e33c3f2390"
    sha256 cellar: :any,                 sonoma:        "75c558710f3d49f210a251824ffd22ff52c786bcea59cb95849b10ec1263f201"
    sha256 cellar: :any,                 ventura:       "2f88d8a0073a46e7ae72300251ef2c504823f09a96ac7cb353d97b4ccb2dbd96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a403d35dc2c5d4d5f466bcbc45e9d302f7727ee089efa324f347ffb29cf5892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d618a8be5d4085a9e72e429e9e3156e1467944be7a49f83e491e258b9d9f0f"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.13"
  depends_on "readline"

  on_linux do
    depends_on "acl"
  end

  def python3
    which("python3.13")
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
