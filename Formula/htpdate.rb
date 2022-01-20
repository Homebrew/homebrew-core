class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.3.tar.gz"
  sha256 "74f34b013eba6f99369819fa4b3d48e9ab5e531ad04f6af59cc04e8777c76ed7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9327fd22d0fcb9bf906cfd89629e4feb85e1e8b52be8539bcd97fa8c6a504d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f21fd808e29fa9d850a82a2992576bce261950aaec18faac522df8b118cf0f4"
    sha256 cellar: :any_skip_relocation, monterey:       "9947935a042ed1ca4d417f70c919d714270ebadd7cc1131f67a7cd3d530442c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "86d1f4a02269aeb784a30ffbe34d0c5443765b9a5900f7bb69f88f5b8bc65149"
    sha256 cellar: :any_skip_relocation, catalina:       "5586c55878b1c1a8fc54d80bc56806eb1afec98645f1497c1d7562c045f531c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "830922f150f61f77f03c310093472e54d6c7e2004be8e726347a83ba8381f91b"
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
