class Nailgun < Formula
  desc "Command-line client, protocol and server for Java programs"
  homepage "http://www.martiansoftware.com/nailgun/"

  stable do
    url "https://github.com/martylamb/nailgun/archive/nailgun-all-0.9.1.tar.gz"
    sha256 "c487735b07f3d65e4c4d9bfa9aaef86d0d78128e4c055c6c24da818a4a47b2ab"

    resource "nailgun-jar" do
      url "https://search.maven.org/remotecontent?filepath=com/martiansoftware/nailgun-server/0.9.1/nailgun-server-0.9.1.jar"
      sha256 "4518faa6bf4bd26fccdc4d85e1625dc679381a08d56872d8ad12151dda9cef25"
    end

    # This patch just prepares the way for the next one.
    patch do
      url "https://github.com/martylamb/nailgun/commit/a789fa3f4eefcd24018d4fd89fc9037427533f52.diff?full_index=1"
      sha256 "7beb0f392ff498a28cfe11af4d6b0be2759c7e27262c944e385c7e9e52ae9db4"
    end

    # The makefile is not prefix aware
    patch do
      url "https://github.com/martylamb/nailgun/pull/45.diff?full_index=1"
      sha256 "59edcba5eb804ae0eec4520a1b4aa26eb595ebfd6f8adce663bfa0fa15a563e2"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4d0e4d7cbad1880f6e9d314d448f90f423d6c2c45c268a6cf99b36d103504c58" => :sierra
    sha256 "02cf71ea505409aedd24b227d67b91a24dc1c2db040185424081ecfdb07f3382" => :el_capitan
    sha256 "958b5a30b72b237139cfd7723025f5d9f50f6b6a318fad22c3297f84a48c34eb" => :yosemite
    sha256 "395c49abe28e79d6171f616b2f0cacc317a95aa09123bdee3eae4df4f3249cff" => :mavericks
  end

  head do
    url "https://github.com/martylamb/nailgun.git"

    depends_on "maven" => :build

    # The -Xdoclint used in pom.xml causes a build error on Java 7
    patch do
      url "https://github.com/martylamb/nailgun/pull/70.diff?full_index=1"
      sha256 "802fcb83cd93227dcfa8f988ec5665d980d04087813b776bf25aed15495bdc4f"
    end
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "CFLAGS=#{ENV.cflags}"
    if build.head?
      require "rexml/document"
      pom_xml = REXML::Document.new(File.new("pom.xml"))
      jar_version = REXML::XPath.first(pom_xml, "string(/pom:project/pom:version)", "pom" => "https://maven.apache.org/POM/4.0.0")
      system "mvn", "clean", "install"
      libexec.install Dir["nailgun-server/target/*.jar"]
    else
      jar_version=version
      libexec.install resource("nailgun-jar").files("nailgun-server-#{version}.jar")
    end
    bin.write_jar_script libexec/"nailgun-server-#{jar_version}.jar", "ng-server", "-server"
  end

  test do
    fork { exec "ng-server", "8765" }
    sleep 1 # the server does not begin listening as fast as we can start a background process
    system "ng", "--nailgun-port", "8765", "ng-version"
    Kernel.system "ng", "--nailgun-port", "8765", "ng-stop"
    # ng-stop always returns a non-zero exit code even on successful exit
    true
  end
end
