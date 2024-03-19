class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.20.tar.gz"
  sha256 "9e6e57ea60d419a803a024ce6366254efb716266b84eedd58cd980dabcc11674"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/ascii[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae5571c5a971f7719cbb1ac767b690e597f96942ba91e1faed105417c043e224"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40eb6da68a2138e86af8a89f747bd0ebf05684214501eebfc4278217fdba5cfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8c8e2a9e5c73b4e48e3097d9f93b25634b6d97585d6c2d3a048ce6e326c56e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7b81b4b8e352bda1d9a12a8c6c4ffe0d938c3a4d4886cc72846e6c8d6ccf142"
    sha256 cellar: :any_skip_relocation, ventura:        "cefb8f382d5a5b81729c894f8ce67b8462509d2d503a10ce4c6a2df788c29260"
    sha256 cellar: :any_skip_relocation, monterey:       "f617984d052af1378c3d0730219d7d89d384aec6d09fe53b97a6f4b8dc4b12be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f384e1207c05128727a6b2d560d64b63f9f832cde4fe4c2a89e56fa0509b049"
  end

  head do
    url "https://gitlab.com/esr/ascii.git", branch: "master"
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end
