class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.105.0.tar.gz"
  sha256 "41c646970ae406f8f030619e2fcb4e28f8ba4c6aec85f04ba422ef1bb1abdafb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "387dadc061722271b0b03ac9a6bca67fd3d463cfbe0311c36429ba85d4755580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c177b494c2ce982ccc4f40a2012d9683ee7c65edcd5516c5e4930c33603eb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db0a84e5e933afc9001e0f98a6bfc743b90d142637cbebf6e2fe2055d8446d92"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa2fe0a64149124e3470c43a3fa7780d8047597eb0b8939d2915d53e06e736b"
    sha256 cellar: :any_skip_relocation, ventura:       "d3da58d42922f29c40c5786d38f755d40ed04299ee2dce8dec6ed2df5544214e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461aa32bbc8d497fcef751609c026da05ad67c7bccc6f5d5f54a56f1e3bfa309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa543ac46992ac352b87a0f2893454b81428deb83c1c45bf3ef3e28770a34db7"
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
