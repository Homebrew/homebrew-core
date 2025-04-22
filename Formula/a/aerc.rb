class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.20.1.tar.gz"
  mirror "https://github.com/rjarry/aerc/archive/refs/tags/0.20.1.tar.gz"
  sha256 "fbfbf2cc4f6e251731698d6d1b7be4e88835b4e089d55e3254d37d450700db07"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sequoia: "2cd6028c68dc0e5aeb8e82bc07aa4c5b7a925bf7d278d78f827c55a208356664"
    sha256 arm64_sonoma:  "6a7dd569bd087a878888764dbe231530e859bfa177dfe04173a9c244cc3a4490"
    sha256 arm64_ventura: "dec8d978d3efcb21fc615bf145daff38474ff032d22572b03906398366349f59"
    sha256 sonoma:        "d9a7ebee7208939165429112a6acdeabd22095078acdf26d36a32c5202e58b20"
    sha256 ventura:       "3cdfcc6ef2b5e6d2461a5727c187790b955ec79dab57b953101602fb9c7aaa8e"
    sha256 x86_64_linux:  "15fe42751917e3f22f595cc4d67a3e2e573e6c9fe84a154fb222c50e70bb9d2a"
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
