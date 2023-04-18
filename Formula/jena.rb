class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-4.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-4.7.0.tar.gz"
  sha256 "ded25127d507b0e61f5afc0f647a7e864459c5bd1138372126340c019de592e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f93f85cc3630bdd4b6217af161f4cf29a4013c57ee7efc260cbf9b854928319"
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
