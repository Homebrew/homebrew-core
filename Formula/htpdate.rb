class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.6.tar.gz"
  sha256 "3cdc558ec8e53ef374a42490b2f28c0b23981fa8754a6d7182044707828ad1e9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c0e9b954e33c77390997f36c4f0595b4fbf5c745f03630976e8f93a045885dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfead617fa38a6cacd01f760983dd72f587ca0b1d5cb31192835aae5f3480497"
    sha256 cellar: :any_skip_relocation, monterey:       "819881fadf593bbbf4be2a95e63626d0bb866d9ce838192fe8f82e2e7b9f404b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cbc51687acaed114db92084f031d139b9db01d3d6d402fc50f24cc7b4125f6f"
    sha256 cellar: :any_skip_relocation, catalina:       "4d3484226b6458a4b3e20a016f276c821fe5b2628349b8d48745655be686d760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d750d20c8464e6ccdfd4be8ca3d8a9b7a6b182703ad07fd096254bde39860a03"
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
