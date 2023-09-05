class NicovideoDl < Formula
  include Language::Python::Shebang

  desc "Command-line program to download videos from www.nicovideo.jp"
  homepage "https://osdn.net/projects/nicovideo-dl/"
  # Canonical: https://osdn.net/dl/nicovideo-dl/nicovideo-dl-0.0.20190126.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nicovideo-dl/70568/nicovideo-dl-0.0.20190126.tar.gz"
  sha256 "886980d154953bc5ff5d44758f352ce34d814566a83ceb0b412b8d2d51f52197"
  revision 3

  livecheck do
    url "https://osdn.net/projects/nicovideo-dl/releases/"
    regex(%r{value=.*?/rel/nicovideo-dl/v?(\d+(?:\.\d+)+)["']}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "52badfb4e41a21255af84eeb934194421b8ebe6a82e6f577f9825880345b91f8"
  end

  depends_on "python@3.11"

  def install
    rewrite_shebang detected_python_shebang, "nicovideo-dl"
    bin.install "nicovideo-dl"
  end

  test do
    system "#{bin}/nicovideo-dl", "-v"
  end
end
