class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.10.zip"
  sha256 "3f56ac263b9c8d5b43a006688ad9365782856550b116e75281065324a36bc41e"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76284d4b9f5acd122e806c09352d5aa46a886d282f834ee9b572bb0cf95e7bf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "623fecf90727c848822576aef59b461d56cf2975f470cacec58979e75da3d71d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf27cf2cf2dfdad97b9df281e7e2d7db71d6538ad09277c35fe0b170f3ab4e6d"
    sha256 cellar: :any_skip_relocation, ventura:        "401702101fb72380209d403c618a8a8aafb404676f39e8d62db49ba691f20a19"
    sha256 cellar: :any_skip_relocation, monterey:       "f47c87c34616301a5fb1b7dc63e483abf174dcb1e7f12de29ee6a62da3c23fb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0791e9e3e09311d2d34469d65f6d65d55b967ac5edcfa6f34769de024e2e31aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4544e173490d949c466908c0d5239d7aa6eaf66c7705120062013cb5515658f1"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
