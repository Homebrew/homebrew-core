class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-4.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-4.7.0.tar.gz"
  sha256 "ded25127d507b0e61f5afc0f647a7e864459c5bd1138372126340c019de592e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be058ee1269cb05097df1f0d4f22db595e16942f2aec4008ffac4c67ff970a8a"
  end

  depends_on "openjdk"

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
