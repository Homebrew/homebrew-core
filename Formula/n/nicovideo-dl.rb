class NicovideoDl < Formula
  include Language::Python::Shebang

  desc "Command-line program to download videos from www.nicovideo.jp"
  homepage "https://osdn.net/projects/nicovideo-dl/"
  # Canonical: https://osdn.net/dl/nicovideo-dl/nicovideo-dl-0.0.20190126.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nicovideo-dl/70568/nicovideo-dl-0.0.20190126.tar.gz"
  sha256 "886980d154953bc5ff5d44758f352ce34d814566a83ceb0b412b8d2d51f52197"
  license "MIT"
  revision 3

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "3ed938a610ab72d8bd9d90764672eb2ed5d9930e0803929c05b3e34d4c1a815d"
  end

  deprecate! date: "2025-10-23", because: :repo_removed
  disable! date: "2026-10-23", because: :repo_removed

  uses_from_macos "python"

  def install
    # Replace `cgi` usage removed in python 3.13
    inreplace "nicovideo-dl", "import cgi", ""
    inreplace "nicovideo-dl", "cgi.parse_qs(", "urllib.parse.parse_qs("

    rewrite_shebang detected_python_shebang(use_python_from_path: true), "nicovideo-dl"
    bin.install "nicovideo-dl"
  end

  test do
    system bin/"nicovideo-dl", "-v"
  end
end
