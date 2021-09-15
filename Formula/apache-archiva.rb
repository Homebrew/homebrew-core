class ApacheArchiva < Formula
  desc "Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=archiva/2.2.5/binaries/apache-archiva-2.2.5-bin.tar.gz"
  mirror "https://archive.apache.org/dist/archiva/2.2.5/binaries/apache-archiva-2.2.5-bin.tar.gz"
  sha256 "01119af2d9950eacbcce0b7f8db5067b166ad26c1e1701bef829105441bb6e29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7be56a181bec0957d8f4f2936e99a98f737b3f7e146a3f7384b13d9e824919ad"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"archiva").write_env_script libexec/"bin/archiva", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def post_install
    (var/"archiva/logs").mkpath
    (var/"archiva/data").mkpath
    (var/"archiva/temp").mkpath

    cp_r libexec/"conf", var/"archiva"
  end

  service do
    run [opt_bin/"archiva", "console"]
    environment_variables ARCHIVA_BASE: var/"archiva"
    log_path var/"archiva/logs/launchd.log"
  end

  test do
    assert_match "was not running.", shell_output("#{bin}/archiva stop")
  end
end
