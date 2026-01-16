class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.106.0.tar.gz"
  sha256 "b198fde77f7ce4d00d42cd2f5eacc16469162b859367a4c9338bd65fc4be8e2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e50f8848a3060338f0598177d32d5253696503e4da1d08a3b4765ecc19c27265"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02685f788c2fb1c810fe4003fb2175090775ca117215c96622278e5ea1dee40c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82e7b7d0d343dea8df530ddf2467992fb07adb5b6d78e65f9f1f408ec4175ddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9d4f7669c578bfb2e9a3550096568d26a6cb9c3ffd16e1c404f6b27abbdfe1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5888f9e830f2d1c9a7802646abef32250e8eaa0f95d6cecfc861dde941501a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5a35e4c27cbc55ceca2bd60d818085a2a9ba0545b890127570db3778cb0a7c"
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
