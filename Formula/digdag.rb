class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.10.0.jar"
  sha256 "0a3aed836d8af1a47ed53dda63c02ce3ecfec6b564d55b556a18b122dec7f3d7"
  license "Apache-2.0"

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
