class Memtester < Formula
  desc "Utility for testing the memory subsystem"
  homepage "https://pyropus.ca/software/memtester/"
  url "https://pyropus.ca/software/memtester/old-versions/memtester-4.7.1.tar.gz", using: :homebrew_curl
  sha256 "e427de663f7bd22d1ebee8af12506a852c010bd4fcbca1e0e6b02972d298b5bb"
  license "GPL-2.0-only"

  # Despite the name, all the versions are seemingly found on this page. If this
  # doesn't end up being true over time, we can check the homepage instead.
  livecheck do
    url "https://pyropus.ca/software/memtester/old-versions/"
    regex(/href=.*?memtester[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c3829b3c8330abfec948e52e5bae58c7daf8e26bd45e4f62110b674115c419"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf486cb5e72380acf5f3b1396af8d854151452be5be0dc5103322dd27bbbec81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb85d1c32821cb299a52a432788a47a12c9f10b683f7a1eef67c8d135eaeb31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db421b0bd918efef4c65a5fda3c6f87e979d0a3d0af630c09ad1369f835e1729"
    sha256 cellar: :any_skip_relocation, sonoma:        "dafebaa8af7e2774e55142b2b6c8ea9e741c6c69c2c757f6deecdfc5574d0379"
    sha256 cellar: :any_skip_relocation, ventura:       "5429e15d860dc1dc4339ed93beb76756f4b123108c20334a1bc4820043c63d34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c1b9a3a3a300d787761fbb46a118efdf1d70a8d1ab686832207e76c5e2a2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e87a3a5d5b2b187c4e48b815f6e3bd5b70a2e1024add16f0c3ef12952c91e3"
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end
