class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.9.tar.gz"
  sha256 "f93007d2b94e61b6b77bcfa6813401b990aafc909a5d235574ca679304b96ef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fee7923f71d564f3841e4614a273905aea23fe00994afd7dff8ab459b2ac6b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200d61de9d6c5511b0cfdb01e8b6614c887f96502c2ee2cdebcd4e1384b711c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c227228dafaf4b92f36c59224b7dce8bfbacee35a67bd309cd01fa886083176"
    sha256 cellar: :any_skip_relocation, sonoma:        "663c8caaf7afc1f3c32f54b7943cca595eac642390bf87bc90f9380f974f856c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69ab3bd68d98b8973d852fc2ea84892872ef34707ce5a1dda1ccae6a5004a143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7807272878a14df793b2c2b7140429ab65f89d2ddb256acebeceff177c2cf98c"
  end

  depends_on "gradle" => :build
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
