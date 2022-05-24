class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.4.tar.gz"
  sha256 "744f9200cfd3b008a5516c5eb6da727af532255a329126a7b8f49a5623985642"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "306db0e62c4d80d4a1357b8577252f184fc7cbf76f5614ad68319961af4bbe08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd5953f16f4eefd4e6739bd189abee1d4361c11b29cd3721cea016a4ba118eb0"
    sha256 cellar: :any_skip_relocation, monterey:       "4574591a62987c84be9f567a0f4c398fa144897e0c234038d8fca2d654221783"
    sha256 cellar: :any_skip_relocation, big_sur:        "4201b9da6ad9cffc5b60b5ab1bfcb2c93863a57340692b080d09269c9d5a9fd9"
    sha256 cellar: :any_skip_relocation, catalina:       "ae5e0c72c2cbc815739ac14af64020c229387938acf0a5a886726ad8002027b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a07d9aede354778983c15ee643b631fd3cf198f6b4466a932d65a528db1344a"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{sbin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
