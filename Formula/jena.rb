class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-4.8.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-4.8.0.tar.gz"
  sha256 "9006e11f41360b54e8c43420154a96c6f92709e1596eda8584e9a2489fff7225"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f04f07a187ef177a2aa54a9d3535ab222c02ce6c98e1625967c28268399c172"
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
