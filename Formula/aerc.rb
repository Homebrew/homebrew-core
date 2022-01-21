class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.7.1.tar.gz"
  sha256 "e149236623c103c8526b1f872b4e630e67f15be98ac604c0ea0186054dbef0cc"
  license "MIT"
  revision 1

  bottle do
    sha256                               arm64_monterey: "57d6954219e420d87ac3eb38d66c832c5b4ddb3b16aabfd49924627fbf749007"
    sha256                               arm64_big_sur:  "1b787d11b8fa5b0d9ca84709b336d9f9441c4575a120e27badd6d904a35b25c5"
    sha256 cellar: :any_skip_relocation, monterey:       "2f3a05cdf69a6cb052634eeaeb4dc549e6c692819c4f6ac8cbb013e6904504fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c555c1d4fdc5282c6d949c8127a14fa77e1b71430dde12d4a3d40816b9dacd5"
    sha256 cellar: :any_skip_relocation, catalina:       "095d2a04f8972f299126c0c5e8d62177d4149188fe160976452f5ae2f9579abe"
    sha256                               x86_64_linux:   "30253e2224744fb1d20d01a0586f773d08908d8d315e17f45570eabc565ab5c6"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "SHAREDIR=#{opt_pkgshare}", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
