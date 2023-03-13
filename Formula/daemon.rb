class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "https://libslack.org/daemon/"
  url "https://libslack.org/daemon/download/daemon-0.8.1.tar.gz"
  sha256 "938a42d6c80d2cc919b40845db6c82e747adbe03b2daab91510a3194c26c8e6d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?daemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e0e0fe331100a496c1d17a6565b5defdb8a75b67ae7c773fbc5c2fef51cb667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900d4305256eb376e8e0211bda4d08984dd822bd60a7ee0a03758d3ed7e7287d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c41545411b2f4b31dc059df14eb622bfd30586c1f2bd3af7f4e0514bb5001277"
    sha256 cellar: :any_skip_relocation, ventura:        "9c42ea135675342665a745d7b4ddb859904dc6a4bf248308d4f6416ea709643d"
    sha256 cellar: :any_skip_relocation, monterey:       "78ea338beb10906494268d771002b4fc246297019637746095a1657f782dca04"
    sha256 cellar: :any_skip_relocation, big_sur:        "224349f2fd389edc70b78ef94b2df74251da1c659792b0dea21b9955fb57efae"
    sha256 cellar: :any_skip_relocation, catalina:       "e631aea609e5e1b623b39b735c0a76e391ba117c920ff5fc9d185ff8e9ea332f"
    sha256 cellar: :any_skip_relocation, mojave:         "df18db1a4c13107967c7e78e398b658823036279e4baf0c94ea5504d298f2d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c45d4005b1fe715ad381a458c256af3cf5dd0d0575a2067f6535875d048f7e88"
  end

  def install
    system "./configure"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
