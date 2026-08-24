class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.4.tar.gz"
  sha256 "af1501a93443d57fbe0c01d6882eecf0a279fe9741b21f7500e2f49e1c2dc113"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "388bf17cf8e473b9b656328b03d4251a2d2caec2fc7b50175038ece3ed6d856c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66c6b684cb8163762910058023adf25fcb841ba727c93382461316ada514bb69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f15e7f1a8b100de15ad0f7f8518b822556d9981a99481e56247cb27ccffc559f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0388fd05a8223e3180648a1211b8d4eb234662d71715fc18e5c1e8a293735354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0586623127425898462bff707a33baa9e9c886e4ecf98680d5ffbdb1548a4c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b064ad76a1471f99cfc7f261af9e74072c9cc809f7ec7fb4c391db283f6298"
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
