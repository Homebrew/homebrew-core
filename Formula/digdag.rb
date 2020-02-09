class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.9.41.jar"
  sha256 "1dc76896573a0cbb1e36f505bf61e16d7bb4b62a2798406a69deecccde780a40"

  bottle :unneeded

  depends_on :java => "1.8"

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
