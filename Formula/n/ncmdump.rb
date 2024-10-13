class Ncmdump < Formula
  desc "Convert Netease Cloud Music ncm files to mp3/flac files"
  homepage "https://github.com/taurusxin/ncmdump"
  url "https://github.com/taurusxin/ncmdump/archive/refs/tags/1.2.1.tar.gz"
  sha256 "a1bd97fd1b46f9ba4ffaac0cf6cf1e920b49bf6ec753870ad0e6e07a72c2de2d"
  license "MIT"
  head "https://github.com/taurusxin/ncmdump.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5cb059fc2cc8ec831eef8e54ccbf72efbada242917cbe95ce19b33a129ba6949"
    sha256 cellar: :any,                 arm64_sonoma:   "6b6ea8422cf6c07ba41cdec25cd75e74881a0b9d131ca4fc4e7fa5a36a45ccae"
    sha256 cellar: :any,                 arm64_ventura:  "78c634b892549c682cd00c6962208eb52b451c184356d7d1629f6c1206beeab3"
    sha256 cellar: :any,                 arm64_monterey: "af2c32f41f65892c7b8d2e09972e438827624e440d438d65ec13c56508f8445c"
    sha256 cellar: :any,                 sonoma:         "62112dfde17a6a5e81071383e42befcb8b29660ccc4851dcb62209d9f2aeb8be"
    sha256 cellar: :any,                 ventura:        "05583fb35e51d6227ba2dbfd43052a60a362af345ae7e70a9acf284404bda5db"
    sha256 cellar: :any,                 monterey:       "157a0d4a3b8860df60878495e101b2264eb5e2c740e3fa1232af96f945667b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef82870ff5763efecb19096dd73cc4090c392d694cdce5e4e1d22cd169cb568"
  end

  depends_on "taglib"

  def install
    os = OS.mac? ? "macos-" : "linux"
    arch = Hardware::CPU.intel? ? "intel" : Hardware::CPU.arch.to_s if OS.mac?
    system "make", "#{os}#{arch}"
    bin.install "ncmdump"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/taurusxin/ncmdump/516b31ab68f806ef388084add11d9e4b2253f1c7/test/test.ncm"
      sha256 "a1586bbbbad95019eee566411de58a57c3a3bd7c86d97f2c3c82427efce8964b"
    end

    resource "homebrew-expect" do
      url "https://raw.githubusercontent.com/taurusxin/ncmdump/2e40815b5a83236f3feb44720954dd3a02eb00f1/test/expect.bin"
      sha256 "6e0de7017c996718a8931bc3ec8061f27ed73bee10efe6b458c10191a1c2aac2"
    end

    resources.each { |r| r.stage(testpath) }
    system bin/"ncmdump", "#{testpath}/test.ncm"
    assert_predicate testpath/"test.flac", :exist?
    assert_equal File.read("test.flac"), File.read("expect.bin")
  end
end
