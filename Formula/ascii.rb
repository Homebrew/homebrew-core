class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.18.tar.gz"
  sha256 "728422d5f4da61a37a17b4364d06708e543297de0a5f70305243236d80df072d"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/ascii[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c42b02694d8703f1836d83604657231e06bbf02bf7ec9dc49d3f2182db6729ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "742c3b7dc29fc1df468027631c0bee9e5db9ee562adcc54f6081291d27ab0295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "961354b48b260c83374340b6f50bb440977edc81ffa6cb11293bd6265f94dd3e"
    sha256 cellar: :any_skip_relocation, ventura:        "b9153efffb59622c7cd261653a3937f5f7a7d3b1f41176425c3b4408a5b4ce13"
    sha256 cellar: :any_skip_relocation, monterey:       "3512701bc58ec647bd059ebcf0c56ad6b02fa1c437e51372e6d942aef6910e87"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae1f4bca216200b2633f93da6d99c991f15755a130bd1cbc680377c251555d32"
    sha256 cellar: :any_skip_relocation, catalina:       "2c106e2d3ce3534f09a5ce147f6fc0778e884d06f15e7c272ee99ccabaf947bd"
    sha256 cellar: :any_skip_relocation, mojave:         "d5f4c8fe4ad1467c1708e49268a42f0d201f8c18ed912cf3de330bdf1f219cc1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "858e5bd8f55367349f936f47346a7d4dc2afed7c8f3d9fca16c42071f537f644"
    sha256 cellar: :any_skip_relocation, sierra:         "52fb2a78a1409f4f6db0b59589f773c4427c87a84a7fee1809e5f0a4d50e4d65"
    sha256 cellar: :any_skip_relocation, el_capitan:     "bbb5f365f96e42dfaa8af31f21daa8809b0a628451599fab7bc7509ceeb0d14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31952089908444514e2e97d6d7a325d52136f8d7c8297210045a04608bf49ae8"
  end

  head do
    url "https://gitlab.com/esr/ascii.git"
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
