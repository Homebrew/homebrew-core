class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.9.42.jar"
  sha256 "71071424a5beeb881cb4ccb06067a556a3673caf3dc8850dd584357e99134b21"
  revision 1

  livecheck do
    url "https://github.com/treasure-data/digdag.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded

  depends_on "openjdk@8"

  def install
    libexec.install "digdag-#{version}.jar"
    (libexec/"bin").write_jar_script libexec/"digdag-#{version}.jar", "digdag"
    (libexec/"bin/digdag").chmod 0755
    (bin/"digdag").write_env_script libexec/"bin/digdag", Language::Java.java_home_env("1.8")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/digdag --version")
  end
end
