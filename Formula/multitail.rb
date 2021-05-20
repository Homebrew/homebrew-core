class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://vanheusden.com/multitail/multitail-6.5.0.tgz"
  sha256 "b29d5e77dfc663c7500f78da67de5d82d35d9417a4741a89a18ce9ee7bdba9ed"
  license "GPL-2.0"
  head "https://github.com/flok99/multitail.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "931b37ad30df49390ef2e7c2d191821a735202d38b9fbb85f5ab9b00ed248eea"
    sha256 cellar: :any, big_sur:       "bcba02065b68527b6e4826a42e8577d380b862c02c747a7de81b1aa40ef59dca"
    sha256 cellar: :any, catalina:      "6d0d74b45d02adc52fa6a5f666484c62941457da3cb10e50d65f5d772cc59c02"
    sha256 cellar: :any, mojave:        "933801e9ec5999742cfcea6cc59580f69fc966ad82858326c2a90f68868de60f"
    sha256 cellar: :any, high_sierra:   "57526de43035b0d5d2520d54b252d29c20a4efb146c019ac044ad5067be5351a"
  end

  deprecate! date: "2021-05-20", because: "Upstream website has disappeared"

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
