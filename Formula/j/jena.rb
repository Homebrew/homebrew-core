class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.4.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.4.0.tar.gz"
  sha256 "290a0128f01eb4a237c925afb119f9cabb5fe53e657568aa286ad10caf0eff84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00ea7c0c9ed0be99c6b6fa7d69317494ba642b4ad7b68b728d75f75e744018cd"
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
