class Payara < Formula
  desc "Java EE application server forked from GlassFish"
  homepage "https://www.payara.fish"
  url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/6.2023.1/payara-6.2023.1.zip"
  sha256 "469569935d5d37870c9e4d8dd7df2ae5d46e03518ebe01d4b392617ec9165dbc"
  license any_of: [
    "CDDL-1.1",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
  ]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bba13d42ac963005fb7a7f51308d833d3a466ab07ca488cc16fdda3ab6d87f09"
  end

  depends_on :macos # The test fails on Linux.
  depends_on "openjdk@11"

  conflicts_with "glassfish", because: "both install the same scripts"

  def install
    # Remove Windows scripts
    rm_f Dir["**/*.{bat,exe}"]

    inreplace "bin/asadmin", /AS_INSTALL=.*/,
                             "AS_INSTALL=#{libexec}/glassfish"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export GLASSFISH_HOME=#{opt_libexec}/glassfish
        export PATH=${PATH}:${GLASSFISH_HOME}/bin
    EOS
  end

  service do
    run [opt_libexec/"glassfish/bin/asadmin", "start-domain", "--verbose", "domain1"]
    keep_alive true
    working_dir opt_libexec/"glassfish"
    environment_variables GLASSFISH_HOME: opt_libexec/"glassfish"
  end

  test do
    ENV["GLASSFISH_HOME"] = opt_libexec/"glassfish"
    output = shell_output("#{bin}/asadmin list-domains")
    assert_match "domain1 not running", output
    assert_match "Command list-domains executed successfully.", output
  end
end
