class Groovyserv < Formula
  desc "Speed up Groovy startup time"
  homepage "https://kobo.github.io/groovyserv/"
  url "https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-1.2.0-src.zip"
  sha256 "235b38c6bb70721fa41b2c2cc6224eeaac09721e4d04b504148b83c40ea0bb27"

  bottle do
    cellar :any_skip_relocation
    sha256 "223df3e3e4e7319f85c2d934a1e499cd5362ed8bfd3298e8c0e3621ded502cf4" => :high_sierra
    sha256 "ead38fcf004d04be61e7cb31b725984069668372c8b2b819cf145b77419b2ad6" => :sierra
    sha256 "884a2439775c2dc1627e96fb42e9d91bf13437e54c7f9f7e29f747ca0c141ef7" => :el_capitan
    sha256 "98381f0d0a1f0703e445779a204e0145776682611249457adbcad541bc0aa58e" => :yosemite
    sha256 "0d24747aaa39d8075e262caf1ee21a13f63bf74e68efb8799a3b15ec94ac6599" => :mavericks
  end

  depends_on "go" => :build
  depends_on "groovy"
  depends_on :java => "1.8"

  def install
    # Sandbox fix to stop it ignoring our temporary $HOME variable.
    ENV["GRADLE_USER_HOME"] = buildpath/".brew_home"
    system "./gradlew", "clean", "distLocalBin"
    system "unzip", "build/distributions/groovyserv-#{version}-bin-local.zip"
    libexec.install Dir["groovyserv-#{version}/{bin,lib}"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    system bin/"groovyserver", "--help"
  end
end
