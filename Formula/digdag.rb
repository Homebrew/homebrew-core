class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.9.21.jar"
  sha256 "8a615ce9c3f6b0de71e9ba1d727a5eb721897e1146b541978e525d73b28f6806"

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
