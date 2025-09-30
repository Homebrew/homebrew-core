class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.3.tar.gz"
  sha256 "4dbf0721e4bec764df9a321837ac3c2dd89f1a56293e3a9d23e1c43c222fe969"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "229d7355e65f26b8ff111bf749dc21e04a02c6c8752e344a06011d053db2015e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4732f6d90693673b180bb1c78f9566137f1f33cd11c70e11219e552847dc0ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e533caf6e467cc84a4dcba39d19f248959e53f6322b8bec719b386aa4ce47710"
    sha256 cellar: :any_skip_relocation, sonoma:        "810fb8ce15100e94af5c3a00959987b2edfd2846c44165a2758923a19ca4f5fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f758abc52b8d0cdd2b75c7906ecc3bc3ad1417be935b7d160fd2a088e415eaed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f956450fe893daf91c7701b4cdca2c06c485bde7e5bf5341603afc9bb4689368"
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
