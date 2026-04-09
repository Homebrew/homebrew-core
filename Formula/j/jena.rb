class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-6.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-6.0.0.tar.gz"
  sha256 "37c4cf284c7050d765acf076dffa909b4f22a3f247ab76c3cd5a0277ca2de954"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8344e038e7fa40a6b4263612941d56c383d5e5c450dd140114509b8abe46e9dc"
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
