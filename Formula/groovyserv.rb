class Groovyserv < Formula
  desc "Speed up Groovy startup time"
  homepage "https://kobo.github.io/groovyserv/"
  url "https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-1.1.0-src.zip"
  sha256 "4d425c606fba54c6a9e3babc79f178de470fc3d5479a1561d947ca7045b40544"
  head "https://github.com/kobo/groovyserv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ead38fcf004d04be61e7cb31b725984069668372c8b2b819cf145b77419b2ad6" => :sierra
    sha256 "884a2439775c2dc1627e96fb42e9d91bf13437e54c7f9f7e29f747ca0c141ef7" => :el_capitan
    sha256 "98381f0d0a1f0703e445779a204e0145776682611249457adbcad541bc0aa58e" => :yosemite
    sha256 "0d24747aaa39d8075e262caf1ee21a13f63bf74e68efb8799a3b15ec94ac6599" => :mavericks
  end

  depends_on "go" => :build
  depends_on "gradle" => :build
  depends_on "groovy"

  def install
    # Sandbox fix to stop it ignoring our temporary $HOME variable.
    ENV["GRADLE_USER_HOME"] = buildpath/".brew_home"
    system "gradle", "clean", "executables"

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries except _common.sh
    bin.install_symlink Dir["#{libexec}/bin/g*"]
  end

  test do
    system bin/"groovyserver", "--help"
  end
end
