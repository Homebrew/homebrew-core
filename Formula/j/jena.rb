class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.0.0.tar.gz"
  sha256 "49ee3baec829f15e98a6fd101ebc23217ac33dc84cd674a5fc699458c12f2c8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da38fa75dfea187764ab10e292403ef4c1d9c7e611900c38eea3831bbe2635f4"
  end

  depends_on "openjdk"

  conflicts_with "samba", because: "both install `tdbbackup` binaries"

  def install
    env = {
      JAVA_HOME: Formula["openjdk"].opt_prefix,
      JENA_HOME: libexec,
    }

    rm_rf "bat" # Remove Windows scripts

    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  test do
    system "#{bin}/sparql", "--version"
  end
end
