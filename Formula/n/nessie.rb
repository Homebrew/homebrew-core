class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.3.tar.gz"
  sha256 "0d4c8391f34f5fab39817f1f676564b0381a229d840e34bc019bd36df19ea85e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5341f049e42020cb03b73ba9cb8f7fae91ae04ad800ee4953769d9f2fdef98b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d7f835c45314dc90662e1a50e12daa85514d9e1cc4b12cf9b70027a6fecdd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bc70f6f01fe5f283db66e55fe718223bc812467d693da0ea50e113e1b1a0abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7c57e23f2e9075e69c6a3f1c49a1721185b096bb6857c5b3fb00e17e5ab6aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "993cccf2033de3baf2bee8a1e92beb0b3ce5612dd8ada38707f00dd91b2c32aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00c719e5ae29e1fe90a20f8cefcf755c2622df73ccfd2abe7e142ea77e0eacca"
  end

  depends_on "gradle" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie", java_version: "21"
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
