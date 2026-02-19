class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.2.tar.gz"
  sha256 "b75d4a68e1809159dd1b2b9557b4f7b85315836854892d9290727d031c3ccc79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f30b9a26bc504a171fefc54ec2b8405a12d380c8c88aa86c7df050d68b57662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "851a53febee83101e286cd96adde7809a33ee594db939772ea3a121b9b0e1b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a27b942b97e0e723b86a5e653232c0a34f0875376099abd4d63e00881ac43761"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1b7efdb9d073da0c50fe45bcb0dd633f88b7bace62ef92edec447a245b343e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfef12228544e9182d2587674a60403e7ea11fc0f408cf318f00fce2a1a6ff87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2be442ad6bf0e132991f7a1bd362875d34d9e84379eb0f957e514df52c5046b"
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
