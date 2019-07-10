class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.9.38.jar"
  sha256 "d3bc625ea5b9a4bf7a02c3b7d24aea6e74934236a2a0a2d153315cb87e28e59d"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "digdag-#{version}.jar" => "digdag.jar"

    # Create a wrapper script to support OS X 10.9.
    (bin/"digdag").write <<~EOS
      #!/bin/bash
      exec /bin/bash "#{libexec}/digdag.jar" "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/digdag --version")
  end
end
