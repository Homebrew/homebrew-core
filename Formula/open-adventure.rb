class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.16.tar.gz"
  sha256 "1864945c085709c991fe905e9b1c9fd3d29e712fb1c46aa7ec4cdec4e88b6424"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e6f2d3f7a760d964064cee9c866733598248904d490c977f0d4a730dbfcd7ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16eb8d8d02295df84ddc94176aed567869161c6cb61bb223d7223e17e1ec8cb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "195f5a0edff650d5de1ce70899c466b0d29fe64f04bd6667bb8e8f4b357fcc7f"
    sha256 cellar: :any_skip_relocation, ventura:        "4a3c131645f948efa59328b8820f21b67060c0fbf08fb0444d05d17858798580"
    sha256 cellar: :any_skip_relocation, monterey:       "62e6659adad76fa8cad53f9dcab9692182d292cbd844e86700f58702a0fe7fdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc2567ca7d9614aa10bc35dac478f3dc6665968262197dc64a399ae29daef50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc81be4f42c271404e5e0a21113b3dad586845abda18af69166298c3b732e69"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.11" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system python, "./make_dungeon.py"
    system "make"
    bin.install "advent"
    system "make", "advent.6"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end
