class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.5.tar.gz"
  sha256 "30918d62dfdf903a5c0475ab3f88c21fc4ddcc8884a1161244c13fbcf909804c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44d53b02db0cddb6cca9f99f59c66b234df8dc6ac6f3e3b824faf0d70a3b8193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a53aa2765c718f90e87d9c762dc1e9d44c9df69e56a81bb9e7347449869e7d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc72ba3b6160abf49e4213056893f22b67d487b55bd728b9f1c7810689990517"
    sha256 cellar: :any_skip_relocation, sonoma:        "a116060b2dfb5ab7992b96739e0b54b6b003b132d55b2e86dd55b15e3f89f679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8c25e7b1d653814526f34718088022ae0aacac62d2be3ccff76705446e27280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd69d8a73dcd0ae9413af0057eba883a378870379daceba032bf4d8ee4da479"
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
