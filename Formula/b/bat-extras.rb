class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https://github.com/eth-p/bat-extras"
  url "https://github.com/eth-p/bat-extras/archive/refs/tags/v2024.06.01.tar.gz"
  sha256 "fcbac015b80a06332d7f47244a04c4be3797867a8937fb56ef260d5c8e7e8802"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e2bce99746062a29a001cb92535230349e768267a7180ee1fbbf9709192205b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efc571ed9b0e1b4d8ecf759f9cec5cb75ebbf64e2ede3bd4c97842b579d9610e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4569511880e55b711015625ba7d6e039e0b10c741153b87b9b71f5e484d73b03"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b09c75930e56a3ab87b3d767ba363ea4534438fbb180c20456ebb90c749e78a"
    sha256 cellar: :any_skip_relocation, ventura:        "2766fa6baae8bbea1e2192e813fc490f0197473904db7dda4a4ec3ca53ff8dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "f3bc2dc3c96a6abf44ec30a98d242c28f28b19dd83e255a034cd0021fcf4cec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c02b3d20bcb42fadd74585161e1f74cc934a884860a02e0129926c9184ac4b5"
  end

  depends_on "bat" => [:build, :test]
  depends_on "shfmt" => :build
  depends_on "ripgrep" => :test

  def install
    system "./build.sh", "--prefix=#{prefix}", "--minify", "all", "--install"
  end

  test do
    system "#{bin}/prettybat < /dev/null"
    system bin/"batgrep", "/usr/bin/env", bin
  end
end
