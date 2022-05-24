class ApacheForrest < Formula
  desc "Publishing framework providing multiple output formats"
  homepage "https://forrest.apache.org/"
  url "https://web.archive.org/web/20130606174723/archive.apache.org/dist/forrest/apache-forrest-0.9-sources.tar.gz"
  mirror "https://archive.apache.org/dist/forrest/apache-forrest-0.9-sources.tar.gz"
  sha256 "c6ac758db2eb0d4d91bd1733bbbc2dec4fdb33603895c464bcb47a34490fb64d"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83d565eb783378de1f2650fbd678d197ee0538eac17d186c22c0e8cb4957d230"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "141e43e9268d661881cd2873e71bfce3e7c0e95b92cb6f5786ef0905d0dbb03f"
    sha256 cellar: :any_skip_relocation, monterey:       "16673b394f80d82e534384ddeca8323087f7abf37954e635150f92a6c5f0f0eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2767298b0c6c15419a22f4a9ed56e0eaf8b0f466a23a7edbaf4db0ae7e179871"
    sha256 cellar: :any_skip_relocation, catalina:       "53aed268e732c00ae5d57d4b98287c59f12c124f5a1b925d02aefacdc6dc5132"
    sha256 cellar: :any_skip_relocation, mojave:         "53aed268e732c00ae5d57d4b98287c59f12c124f5a1b925d02aefacdc6dc5132"
    sha256 cellar: :any_skip_relocation, high_sierra:    "53aed268e732c00ae5d57d4b98287c59f12c124f5a1b925d02aefacdc6dc5132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d565eb783378de1f2650fbd678d197ee0538eac17d186c22c0e8cb4957d230"
  end

  deprecate! date: "2020-02-01", because: :unmaintained

  depends_on "openjdk"

  resource "deps" do
    url "https://web.archive.org/web/20161221052851/archive.apache.org/dist/forrest/apache-forrest-0.9-dependencies.tar.gz"
    mirror "https://archive.apache.org/dist/forrest/apache-forrest-0.9-dependencies.tar.gz"
    sha256 "33146b4e64933691d3b779421b35da08062a704618518d561281d3b43917ccf1"
  end

  def install
    libexec.install Dir["*"]
    (bin/"forrest").write_env_script libexec/"bin/forrest", JAVA_HOME: Formula["openjdk"].opt_prefix

    resource("deps").stage do
      # To avoid conflicts with directory names already installed from the
      # main tarball, surgically install contents of dependency tarball
      deps_to_install = [
        "lib",
        "main/webapp/resources/schema/relaxng",
        "main/webapp/resources/stylesheets",
        "plugins/org.apache.forrest.plugin.output.pdf/",
        "tools/ant",
        "tools/forrestbot/lib",
        "tools/forrestbot/webapp/lib",
        "tools/jetty",
      ]
      deps_to_install.each do |dep|
        (libexec/dep).install Dir["#{dep}/*"]
      end
    end
  end

  test do
    system "#{bin}/forrest", "-projecthelp"
  end
end
