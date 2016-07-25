class Groovyserv < Formula
  desc "Speed up Groovy startup time"
  homepage "https://kobo.github.io/groovyserv/"
  url "https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-1.1.0-src.zip"
  sha256 "4d425c606fba54c6a9e3babc79f178de470fc3d5479a1561d947ca7045b40544"
  head "https://github.com/kobo/groovyserv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31f32f93dac174aa311922516715111469adb33ab44e4c7ecdf7787bbb8fe429" => :el_capitan
    sha256 "574847450b751be607198f21d470b5e7cd4693d1dafd634474700d121fc2b4eb" => :yosemite
    sha256 "891d92de6d33ca81ec885640a3a30b37749c272a2c69a37126e31bac2659b59c" => :mavericks
    sha256 "58a7a2dbd1327dd88b5a010b570140c479a1b28940769ac0cff644c7f19e11bb" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    # Sandbox fix to stop it ignoring our temporary $HOME variable.
    ENV["GRADLE_USER_HOME"] = buildpath/".brew_home"
    system "./gradlew", "clean", "executables"

    # Install executables in libexec to avoid conflicts
    libexec.install Dir["build/executables/{bin,lib}"]

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries except _common.sh
    bin.install_symlink Dir["#{libexec}/bin/g*"]
  end
end
