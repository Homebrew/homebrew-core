class PaxConstruct < Formula
  desc "Tools to setup and develop OSGi projects quickly"
  homepage "https://ops4j1.jira.com/wiki/spaces/paxconstruct/overview"
  url "https://search.maven.org/remotecontent?filepath=org/ops4j/pax/construct/scripts/1.6.0/scripts-1.6.0.zip"
  sha256 "fc832b94a7d095d5ee26b1ce4b3db449261f0154e55b34a7bc430cb685d51064"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/ops4j/pax/construct/scripts/maven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b033ca0a10e6011280fce831ec89b49717cf985137b4134caac26da3669c5a5"
  end

  # Needed at runtime! pax-clone: line 47: exec: mvn: not found
  depends_on "maven"

  def install
    rm_rf Dir["bin/*.bat"]
    prefix.install_metafiles "bin" # Don't put these in bin!
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
  end

  test do
    ENV.prepend_path "PATH", Formula["maven"].opt_bin
    system bin/"pax-create-project", "-g", "Homebrew", "-a", "testing",
               "-v", "alpha-1"
    assert_predicate testpath/"testing/pom.xml", :exist?
  end
end
