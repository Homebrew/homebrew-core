class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~sircmpwn/aerc/archive/0.5.2.tar.gz"
  sha256 "87b922440e53b99f260d2332996537decb452c838c774e9340b633296f9f68ee"
  license "MIT"

  bottle do
    sha256 "ed878a3c9bbb1b4a1aa3fff0fa6dbef6304660e535ad4648ef07775ec7dab270" => :big_sur
    sha256 "7515182013440803e6c4326493c627a97e78c15d3dfebfe7f8775d995b6fb2cb" => :catalina
    sha256 "175a1dab5a7ecd2638f62dcfd260d6d50d39b069518ca968f5e19cbfff57ace4" => :mojave
    sha256 "6c092fe0c10a3a6e6b5b4b17d33d07e8b90abd4c7c0014b22b16707c8d1836cc" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
