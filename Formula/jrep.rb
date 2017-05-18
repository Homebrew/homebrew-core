class Jrep < Formula
  desc "grep-like utility written in Java"
  homepage "https://github.com/cheusov/jrep"
  url "https://github.com/cheusov/jrep/archive/1.1.1.tar.gz"
  sha256 "0d56a9892a7abf0f53a52aa448fac90cd07b78fa08fa88e1567a95157c7d2fac"

  depends_on "maven" => :build
  depends_on "mk-configure" => :build
  depends_on :java => "1.7+"

  def install
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    ENV["MAVEN_OPTS"] = "-Dmaven.repo.local=" + `pwd`.chomp + "/m2repo/"
    ENV["PREFIX"] = "#{prefix}"
    ENV["MANDIR"] = "#{man}"

    system "mkcmake"
    system "mkcmake", "install"
  end

  test do
    system "#{bin}/jrep", "a", "/etc/hosts"
  end
end
