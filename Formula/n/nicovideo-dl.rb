class NicovideoDl < Formula
  include Language::Python::Shebang

  desc "Command-line program to download videos from www.nicovideo.jp"
  homepage "https://osdn.net/projects/nicovideo-dl/"
  # Canonical: https://osdn.net/dl/nicovideo-dl/nicovideo-dl-0.0.20190126.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nicovideo-dl/70568/nicovideo-dl-0.0.20190126.tar.gz"
  sha256 "886980d154953bc5ff5d44758f352ce34d814566a83ceb0b412b8d2d51f52197"
  license "MIT"
  revision 3

  livecheck do
    url "https://osdn.net/projects/nicovideo-dl/releases/"
    regex(%r{value=.*?/rel/nicovideo-dl/v?(\d+(?:\.\d+)+)["']}i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "d20fe029f025c4cadd5c3ed25d58cd88886e32fd6d6fe16f51bfc0e2233bb80a"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "nicovideo-dl"
    bin.install "nicovideo-dl"
  end

  test do
    system bin/"nicovideo-dl", "-v"
  end
end
