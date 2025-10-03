class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.5.0.tar.gz"
  sha256 "6ad45c5bd5373e35ff1374214dae9d05fbdbd7d45bde7e913a92de1a29c60f55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "003970ddf4e030bd531bc1f07e0ca77e8d6d44f0925bbf967284d157e1c34b08"
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
