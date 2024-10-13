class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.18.2.tar.gz"
  sha256 "78408b3fe7a4991a6097c961c348fb7583af52dff80cbfcd99808415cf3d7586"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "02bd542c1b8a84826e33c592cb850888d2c445f8cf7cad22cb37edb42f409731"
    sha256 arm64_sonoma:   "0e45fdcaf540c298c7b135144d7eb67eddddd4b26ae5513842c3c4e5f954ad22"
    sha256 arm64_ventura:  "9465440c9a9799b8e4b6544bb369c4cc988836e86bb8c91f0036f463f774c526"
    sha256 arm64_monterey: "39c67445c4e18f65a634633632aabff711a1cf94cabcf84e3ee7b94a4fbf1209"
    sha256 sonoma:         "1fcfc86803cb283e391daea387457fafbf50019706f4a7105058fe8f53804b70"
    sha256 ventura:        "cdabe2f89e91c3cd42eeea0851bb1d91a0aa535229c15e510f566dd32d21d267"
    sha256 monterey:       "b7197c015ac239b9f7695386f90654ef03f0541497dc218727835508254b5bf9"
    sha256 x86_64_linux:   "589b8963d1e494d234d37f0e1982e67eecd6a13b36faf11840a0146a455b4c8c"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"aerc", "-v"
  end
end
