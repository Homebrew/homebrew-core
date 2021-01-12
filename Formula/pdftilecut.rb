class Pdftilecut < Formula
  desc "Sub-divide a PDF page(s) into smaller pages so you can print them"
  homepage "https://github.com/oxplot/pdftilecut"
  url "git@github.com:oxplot/pdftilecut.git", using: :git, tag: "v0.4", revision: "af9ca3bff60eed47026a6e1c40b6ef85e5b36393"
  license "BSD-3-Clause"

  depends_on "autoconf" => :build
  depends_on "autogen" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "yasm" => :build

  def install
    system "make"
    bin.install "bin/pdftilecut" => "pdftilecut"
  end

  test do
    system bin/"pdftilecut", "-h"
  end
end
