class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-6.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-6.3.0.tar.gz"
  sha256 "43039ed44b55ecee8010722cb910297b42d5fd321c80642ed47732fe716cae0f"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "57c3f37ad8c125479cca2f9484e07af7e3ecaabef91d688c8b5b56d2d8fcb4c5"
    sha256 cellar: :any_skip_relocation, all: "305322951133981180b8537af34ab18114060b21b873f08fab7616c42a2a984f"
  end

  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `update` binaries"
  conflicts_with "samba", because: "both install `tdbbackup` binaries"
  conflicts_with "tdb", because: "both install `tdbbackup`, `tdbdump` binaries"

  def install
    env = {
      JAVA_HOME: formula_opt_prefix("openjdk"),
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
