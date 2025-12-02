class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.6.0.tar.gz"
  sha256 "b39aa6cca06b103ed4d509b42eee512394088859df2b5367a858927bf1fce728"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ca301fe3164657e555e159d701e5896219d26c65b7cd433b7734b3b89e118d0"
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
