class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.3.0.tar.gz"
  sha256 "4ccbd06f6714faecf809ec9692c5987ee7b243b36952c1b8b1aa0955756477b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d4691f030d15115b0517e3209b63f141a3c10a721ff894c0a21cd7f30fbdf92"
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
