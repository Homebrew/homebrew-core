class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://github.com/treasure-data/digdag"
  url "https://dl.digdag.io/digdag-0.8.14.jar"
  sha256 "97dce8e88b832bee099c4d89b00b24baceb4d0c9c0d1c73ddaebe5ff56313943"

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
