class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.9/apache-opennlp-2.5.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.9/apache-opennlp-2.5.9-bin.tar.gz"
  sha256 "de06487900cce46d24f9d38be05ad92777c3e316b56302bff7f47ef09c55fa13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9c439771c5d41e0bcdf840d8253abde31ae7680fe429e1d3d7139af540599bc"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    output = pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends", 0)
    assert_equal "Hello , friends", output.lines.first.chomp
  end
end
