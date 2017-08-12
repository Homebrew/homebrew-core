class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.9.14.jar"
  sha256 "11c68f8888095d0d3011814810a8603d5638dee58d4a846878f881985ff67bca"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "digdag-#{version}.jar" => "digdag.jar"

    # Create a wrapper script to support OS X 10.9.
    (bin/"digdag").write <<-EOS.undent
      #!/bin/bash
      exec /bin/bash "#{libexec}/digdag.jar" "$@"
    EOS
  end

  test do
    ENV.java_cache
    assert_match version.to_s, shell_output("#{bin}/digdag --version")
  end
end
