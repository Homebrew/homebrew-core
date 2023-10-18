class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.net/"
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.29/htmlcleaner-src-2.29.zip"
  sha256 "9fc68d7161be6f34f781e109bf63894d260428f186d88f315b1d2e3a33495350"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80b49c3d2908f0b16012c0df1ca1b8106b89c3cf32acec145297e73fd9b07db2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a24575c2b43f626d3d9da81c7c5827552373384c34906e311e609d65e443485"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f9df98d6b5f4876d20c9b92912655d90cde869c551749e341df6c7e267d308"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8845ce2d35c04af60ced49eff3a85c9bc36aa04f1bb6aaf4cca88ceaebe4304f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0693691bbeeb073072948882cc808f3614781c2cc641d2e20fad1511ee3f883e"
    sha256 cellar: :any_skip_relocation, ventura:        "92b7d24b687fb475b97e90e783c69f9ef552ee52517d7c15b7f36f1389751bc7"
    sha256 cellar: :any_skip_relocation, monterey:       "9e41d626c3516fc8790e4e5a0dbb25063bca90204847acdf3024ea59bb825b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d1da20c65da61938e3a1f13987a8668eb0c11d7a437ffbf03c25a5d5829253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695a4bdb667ae979c639e63083a696d823992bc37db1fc7deb23502cc54ed63c"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install "target/htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner", java_version: "17"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
