class Payara < Formula
  desc "Java EE application server forked from GlassFish"
  homepage "https://www.payara.fish"
  url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/6.2024.5/payara-6.2024.5.zip"
  sha256 "cc66c5328688c9d766d5e9cc403262df1d6271810c83ba35f9c67ef01f378140"
  license any_of: [
    "CDDL-1.1",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
  ]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1d554d61abc0870b503036f7470d1c7287258212b93293b0b5ca501c6225d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33a7cb887b9a6687802248c4dea0c7cb51662fdf313a9af6b4c317cdac558a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "937f46fb97bd8e7ab9cbc07cafc90a83e52b779fd03a7df4ba1ffef6d04fe7a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b753bdf20e6f4d80cf76a2d1d1e48193c7eeef707f446819392d797c4634590"
    sha256 cellar: :any_skip_relocation, ventura:        "e6de38c3e77ed69dfc13955353ad307ed07ec3753f179f99a76e3966a07a45e4"
    sha256 cellar: :any_skip_relocation, monterey:       "5b34230b4b1a399607997acb4442163b6ad42a3bb67101e55726b5783a08eec2"
  end

  depends_on :macos # The test fails on Linux.
  depends_on "openjdk"

  conflicts_with "glassfish", because: "both install the same scripts"

  def install
    # Remove Windows scripts
    rm_f Dir["**/*.{bat,exe}"]

    inreplace "bin/asadmin", /AS_INSTALL=.*/,
                             "AS_INSTALL=#{libexec}/glassfish"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
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
