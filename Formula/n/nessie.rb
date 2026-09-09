class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.7.tar.gz"
  sha256 "832bc6ce352faf1fc876ab2c23f39d390aaa3d6f4a1b477d2c5d0b78c872bc91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "974ce7b4bb827133a1f995c932ddb5f55724003f848527b98aa86520fb88e00d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f2cbfdd2c504f9ff1edf83b2f7a0064380263f884c940fec3c8bea681cd52e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "776ffb14e98be32aa784630d5b7903e892324299af63cdb45299aae402394319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33d6f27ded76460473bca462e3c79714a545710b53d4c7164e2029d8720d0402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f287b9f169a26d5d17ddc48a017041713d4d080a1d49958a1417a8df396a9e0"
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
