class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-3.17.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-3.17.0.tar.gz"
  sha256 "1c2a51c8a0137c9c12a8928e035351bc6dea99d716a8d2458b9c9467cebc6ec2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

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
