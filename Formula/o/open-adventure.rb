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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da50d95cedf6710e39a27bbd76b888ace398ac67327f17f288017a79aa9ae274"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3236428d53140ff49d8644b02454bca093edb2dfe475733322a4ba91ab5816c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a00d3b046d6b2ead8cc9d813703c19dac975d91332325e21fd11c00ac79fdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "f01a13553c82ef643542de0d7842cf4fb44b64ebbba765c33356f27c59cd253e"
    sha256 cellar: :any_skip_relocation, ventura:        "afd7abb9f76f17e89d0ab93ec220bc4838231eafa7a8553e3bb21ce86e160685"
    sha256 cellar: :any_skip_relocation, monterey:       "1c2b1b8b0fac0c693934f822651749a7daaab7edfcc17ea6d488b8f58a836ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe4b3cf7fccb8954df99da30e0356aa2ad053194a9a2ee740a59292509d797e0"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.12" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
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
