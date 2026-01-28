class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.33.10.tar.gz"
  sha256 "5b7d169b3b0d821dc93c55798e18339594af618f018aae88dff28b8cc6333b00"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8dd1764fdfdcb4e0a3be1c0187a5c9fae165c38130282620f4683d47bc4886f"
    sha256 cellar: :any,                 arm64_sequoia: "9aad3e7860b09e030da32a5800505ebfe0b5fe7a647879db0cff40d919e9767f"
    sha256 cellar: :any,                 arm64_sonoma:  "a4536482d2a0d6d13ec56e1574fb7a6913a561d4548ab7f3428cb289b2b28225"
    sha256 cellar: :any,                 sonoma:        "a132b47d549095e472be6cb7703c0c8cf78f8850b0aa8dadc76210a00120e055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1916cb6c7346701861a8d1206d68eaf8e19bd79ff1e93a9cd60f7c6de26b7a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1419ad06f33c6f879c55e6e40596f58ffd7d83a903c801433ee1f5b993adb5cd"
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
