class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.9.28.jar"
  sha256 "7663ccf303839f53395dba2473759acd5fd8924cadb9bb13d21048f09cb2d02f"

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
