class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-4.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-4.10.0.tar.gz"
  sha256 "1b690287917659fad2382afe7c43b4da694e4957d5d8ecb7b9918d11aacb47e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe9b0cae74763b07e22e2adf4be33f57495dcb6d607b0368b29868a3c07f8ab8"
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
