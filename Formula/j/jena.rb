class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.1.0.tar.gz"
  sha256 "2ec367a3fb362852b293128dee49532df9855aefe3b5724257d4c53d7fceb21e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dffb5fdbed56c65060224008433699c3bb1fe28c0c7726084c695d71c56b764b"
  end

  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `update` binaries"
  conflicts_with "samba", because: "both install `tdbbackup` binaries"
  conflicts_with "tdb", because: "both install `tdbbackup`, `tdbdump` binaries"

  def install
    env = {
      JAVA_HOME: Formula["openjdk"].opt_prefix,
      JENA_HOME: libexec,
    }

    rm_r("bat") # Remove Windows scripts

    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  test do
    system bin/"sparql", "--version"
  end
end
