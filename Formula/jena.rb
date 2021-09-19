class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-4.2.0.tar.gz"
  sha256 "d8f6f88ee3c3f0d3cf25e551aa59a11a039d16314156445553d48917aea638fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1a07fdf2b0c57f9dcf6eaddc97e2dd1bbb3086e7d79ea101673089fa03d7b0c"
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
