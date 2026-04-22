class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.8/apache-opennlp-2.5.8-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.8/apache-opennlp-2.5.8-bin.tar.gz"
  sha256 "e4a45155bbaded55c2c92bf22a5eafda4f0bf53479f8fe977eb2214f9c72b331"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "516160ae9747c39ebc8c8423310634115a92505ff42e6e22d6b1c4faa56da97f"
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
