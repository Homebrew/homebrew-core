class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond"
  homepage "https://github.com/mstrobel/procyon"
  url "https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-0.6.0.jar"
  sha256 "821da96012fc69244fa1ea298c90455ee4e021434bc796d3b9546ab24601b779"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e49bf95df9cae386854919754f48bb49c6b5444fa52b42a4312148b1157c25c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e49bf95df9cae386854919754f48bb49c6b5444fa52b42a4312148b1157c25c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e49bf95df9cae386854919754f48bb49c6b5444fa52b42a4312148b1157c25c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e49bf95df9cae386854919754f48bb49c6b5444fa52b42a4312148b1157c25c"
    sha256 cellar: :any_skip_relocation, ventura:        "5e49bf95df9cae386854919754f48bb49c6b5444fa52b42a4312148b1157c25c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e49bf95df9cae386854919754f48bb49c6b5444fa52b42a4312148b1157c25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c98cad8ada38a9cdf8089be7d9371e448cef29bbec7dcc9109010d55af4ebf"
  end

  depends_on "openjdk@21"

  def install
    libexec.install "procyon-decompiler-#{version}.jar"
    bin.write_jar_script libexec/"procyon-decompiler-#{version}.jar", "procyon-decompiler", java_version: "21"
  end

  test do
    fixture = <<~EOS
      class T
      {
          public static void main(final String[] array) {
              System.out.println("Hello World!");
          }
      }
    EOS

    (testpath/"T.java").write fixture
    system Formula["openjdk@21"].bin/"javac", "T.java"
    assert_match fixture, shell_output("#{bin}/procyon-decompiler T.class")
  end
end
