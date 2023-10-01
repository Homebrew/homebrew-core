class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https://github.com/eth-p/bat-extras"
  url "https://github.com/eth-p/bat-extras/archive/refs/tags/v2023.09.19.tar.gz"
  sha256 "8a9b933f5d954c3a89a8435e7a02b4a80e6e16f6a8cb9ff89056cfde3fe67b20"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57b68b838d0fcdc0348360cbb6c6e7abe3cfbc4599a8fe0af98008b17d5521f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4759ae52b4e8995026af0ba7c01693f88dc546fd0f53df45192045554fdb4ba9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5de1846c871910470050629634408d7354e2b4e6476733480657bc968bf2c9cc"
    sha256 cellar: :any_skip_relocation, ventura:        "f7d798e7c124ba3d7f249001b345f3bdee2d5829897625996cbd55330b91f291"
    sha256 cellar: :any_skip_relocation, monterey:       "6ee0064bfc7e06346ca390a285677ca666c023c6d24dbd2c182a7115a14e3136"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ba0693c1d0ab6cb0cdd1fdb18a769c35f0734164b6b5f5e23f99afc181d6741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0ff45c6d25d4a714e05a3f94a2229c104ad7ca20e0258b8855edaad3b67ad3"
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
