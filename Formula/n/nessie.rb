class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.7.tar.gz"
  sha256 "53946d09f18d3d2b972cc2e5a64cff8eba15fd9b328e91f6c374bc826953639f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be4882e6495a8abf2d6e968bf97d67c0d8794191f86fded2a3a4ebf46a879b63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a004a755e96fa077923efff0d062de49c2595bab5332f663cd70e4790e6680dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1777ee9649fccd703759ce641878995832522c590ed3e070bc0e9812e6b08f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c5d320b133a3514975580835d76ef7abcc389946c2411d40517e69ddd5bf68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9900f2f0a89508339a83c185f7924cd0df9c957427e00dfed7ee2b548fefcef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4d846ba266ff979a4b73e4c36aada9cd2df4fc4d06f46ac17ae477081b33fc"
  end

  depends_on "gradle@8" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie"
  end

  service do
    run [opt_bin/"nessie"]
    keep_alive true
    error_log_path var/"log/nessie.log"
    log_path var/"log/nessie.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end
