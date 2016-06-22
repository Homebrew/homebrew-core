class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://github.com/treasure-data/digdag"
  url "https://dl.digdag.io/digdag-0.8.1.jar"
  sha256 "92e79f5eb26b8992c9d510206c71f64fe4765c0c51a4e4cb62279aa1a4231ec7"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "digdag-#{version}.jar" => "digdag.jar"
    # Create a wrapper script to support OS X 10.9.
    # See https://github.com/Homebrew/homebrew-core/pull/2012#issuecomment-226407948 for the detail.
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
