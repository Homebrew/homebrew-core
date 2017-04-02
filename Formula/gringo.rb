class Gringo < Formula
  desc "Grounder to translate user-provided logic programs"
  homepage "https://potassco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/potassco/gringo/4.5.4/gringo-4.5.4-source.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/gringo/gringo-4.5.4-source.tar.gz"
  sha256 "81f8bbbb1b06236778028e5f1b8627ee38a712ec708724112fb08aecf9bc649a"

  bottle do
    cellar :any_skip_relocation
    sha256 "10fdd80c67761f30f49f95ec2e79f0f8cea9c8109053a07853491846af30fc6a" => :sierra
    sha256 "441c81748e551106a923ccd61298f98c8b5e46cba684fc2e0031a4fe11f1d0ae" => :el_capitan
    sha256 "e9b5ee97a0a0b8c14a66d6359936259b7edc96c2013531c250903a03df65bfb0" => :yosemite
    sha256 "7215d8a23fe6052bd67e4ce8b5537da6e16236f07fe387bd7b29fa5f9ee35ca9" => :mavericks
  end

  depends_on "re2c" => :build
  depends_on "scons" => :build
  depends_on "bison" => :build

  needs :cxx11

  def install
    # Allow pre-10.9 clangs to build in C++11 mode
    ENV.libcxx

    inreplace "SConstruct",
              "env['CXX']            = 'g++'",
              "env['CXX']            = '#{ENV.cxx}'"

    scons "--build-dir=release", "gringo", "clingo", "reify"
    bin.install "build/release/gringo", "build/release/clingo", "build/release/reify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gringo --version")
  end
end
