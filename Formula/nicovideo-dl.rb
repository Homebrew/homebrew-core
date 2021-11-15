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
    sha256 cellar: :any_skip_relocation, all: "bd14d4d14a48df2134225b9fd2de504a41f505140eeab321d49521298fb86345"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "nicovideo-dl"
    bin.install "nicovideo-dl"
  end

  test do
    system "#{bin}/nicovideo-dl", "-v"
  end
end
