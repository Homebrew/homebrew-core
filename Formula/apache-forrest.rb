class ApacheForrest < Formula
  desc "Publishing framework providing multiple output formats"
  homepage "https://forrest.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=forrest/apache-forrest-0.9-sources.tar.gz"
  mirror "https://archive.apache.org/dist/forrest/apache-forrest-0.9-sources.tar.gz"
  sha256 "c6ac758db2eb0d4d91bd1733bbbc2dec4fdb33603895c464bcb47a34490fb64d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d73ea48f2d9367f55f3d4be01fca55263d70583d9052f025d498920f19400111" => :catalina
    sha256 "6128ea9bb47128eddc98787e8c874e100195e9c29062df10395b0fc9159c76f1" => :mojave
    sha256 "66a6c2fb9f2d6db49bae90431d841378b07925d746d33bb77bfa9b41deff7e9e" => :high_sierra
    sha256 "9d5b65be3ab328e2861e47e842530cba5d393e7ac2e6a09af0f2f4731fb0e34e" => :sierra
    sha256 "615ab5a39fcc19a110ebab166c05a614149374e65c5f9a7a4522fa400b8d4118" => :el_capitan
    sha256 "cd0e4ceeb9e01118fe69bee3f80ccff63a951e01bf76c87146185ae6fe474c09" => :yosemite
    sha256 "a0e06c41204932f1427e38d47b3c4442dea7f7c3312f959faf1b725d35d85a52" => :mavericks
  end

  depends_on "openjdk"

  resource "deps" do
    url "https://www.apache.org/dyn/closer.cgi?path=forrest/apache-forrest-0.9-dependencies.tar.gz"
    sha256 "33146b4e64933691d3b779421b35da08062a704618518d561281d3b43917ccf1"
  end

  def install
    libexec.install Dir["*"]
    (bin/"forrest").write_env_script libexec/"bin/forrest", :JAVA_HOME => Formula["openjdk"].opt_prefix

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
