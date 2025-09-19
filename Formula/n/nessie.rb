class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.2.tar.gz"
  sha256 "5717bcb8200a705673620ab5e77fa0806f2b5a3add24febd2f3ae05c2c463834"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdfff2a72dd408c8859b857c5f512cb12f711c8c222a30d2b02150bd15590aea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0690c99f464c6457b7c1c406d24f907f45f25633a2c53b5ed3ffa577487db5be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33b0d9da42214b503c9ee3afdcd456d7cbb9c91d3e022777c1754757dfcd1bce"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f26e87d7ca61f70a6ad1b99ec29cbd8929774a0c515c9917d49929e4e2f9be7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855b7041417e51cdedb7411e83c6c2c8d4bf1f0d25b08337e9db1c69bf6e8a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28192d42f3b1ef257e0f4f922550f9f41727ace1d0119b957fdaeb092bfeec5d"
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
