class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.1.tar.gz"
  sha256 "88c6aab3386324e2b3d1dd22af1ee3fadf1079ef3104be9f7fd2a3f647d69a62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a348660bb061fb16c60c4ab2559a46e4989f0b0201adabe4638d772e5533c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e157b847cb9c3527279f05e107bbf3d98ad5a2c1d825f976236f8644a443d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8034f5570288b73e6dde400f24169f7bc95afbe58b43992acf61144ba6d811d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2472f0838fb00df185379c12b5c15eeb46122978bcc3acd1e05e7a6481f2ad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a039d3d2fa5e4d9659956e72c7ce3b1910cf7bb2dc3be44f5db3c1348e5382fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8e998605d39f5eb588826fbb0ec1052e549ea9effd6bc8a389d8ebb29fafec"
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
