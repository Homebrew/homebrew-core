class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.30.tar.gz"
  sha256 "5ae782d7eb19042cd05e260c8ec0fe4d0544e51716885a4b1e96a673576bd998"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "fc25441587a212a0e2ff3ea4f3da8ea8ae4ee6eb056734f34457e359226c5075"
    sha256 cellar: :any,                 arm64_sonoma:  "ccbf32aa2aad3feca89328629e5639cc590cceb84e0819014d92c7b9edc7cd09"
    sha256 cellar: :any,                 arm64_ventura: "28c538465291b8b65247cee90652ab3a81bdc4dff555386798a7cb2cdcedd87a"
    sha256 cellar: :any,                 sonoma:        "6524f7e716bd15f1a0b53de139f1ddbef314ef15700e5c1d0b3e6bfe04127a7c"
    sha256 cellar: :any,                 ventura:       "2d0e01a5a206136515d82bca07ae11c478995e9f1f9bb7d70c251428992f5519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "416ea9344c2a5e145eb76c0cc7238ba0214a85fbec51a3c2ba4335fe8ec813c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984b829e7f58382aa6a5af27221be3424fef32dca3c7965c37dd04c7e332a575"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"
  depends_on "ncurses"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "Trying to initialize curses library...", File.read("test")
  end
end
