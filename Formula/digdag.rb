class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://github.com/treasure-data/digdag"
  url "https://dl.digdag.io/digdag-0.8.17.jar"
  sha256 "30a474247ee5b8efa6d2002f12cbf24e6089bf593eac946161c8496c167bcda7"

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
