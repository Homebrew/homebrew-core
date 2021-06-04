class Artifactory < Formula
  desc "Manages binaries"
  homepage "https://www.jfrog.com/artifactory/"
  # v7 is available but does contain a number of pre-builts that need to be avoided.
  # Note that just using the source archive is not sufficient.
  url "https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/6.23.21/jfrog-artifactory-oss-6.23.21.zip"
  sha256 "086263fdf259bd9115c9e313f8401ae321c3cd57a7be8823ef8416254c41e2a1"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/"
    regex(/href=.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9750899427872732e3e1698791d39fb9a40eb1696b293a9e42dae2b80abea616"
  end

  depends_on "openjdk"

  def install
    # Remove Windows binaries
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Prebuilts
    rm_rf "bin/metadata"

    # Set correct working directory
    inreplace "bin/artifactory.sh",
      'export ARTIFACTORY_HOME="$(cd "$(dirname "${artBinDir}")" && pwd)"',
      "export ARTIFACTORY_HOME=#{libexec}"

    libexec.install Dir["*"]

    # Launch Script
    bin.install libexec/"bin/artifactory.sh"
    # Memory Options
    bin.install libexec/"bin/artifactory.default"

    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def post_install
    # Create persistent data directory. Artifactory heavily relies on the data
    # directory being directly under ARTIFACTORY_HOME.
    # Therefore, we symlink the data dir to var.
    data = var/"artifactory"
    data.mkpath

    libexec.install_symlink data => "data"
  end

  service do
    run opt_bin/"artifactory.sh"
    keep_alive true
    working_dir libexec
  end

  test do
    assert_match "Checking arguments to Artifactory", pipe_output("#{bin}/artifactory.sh check")
  end
end
