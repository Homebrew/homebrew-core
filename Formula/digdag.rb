class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://github.com/treasure-data/digdag"
  url "https://dl.digdag.io/digdag-0.8.1.jar"
  sha256 "92e79f5eb26b8992c9d510206c71f64fe4765c0c51a4e4cb62279aa1a4231ec7"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Add prefix a shebang before install for OS X 10.9.
    # See https://github.com/Homebrew/homebrew-core/pull/2012#issuecomment-226407948 for the detail.
    inreplace "digdag-#{version}.jar", /\A/, "#!/bin/sh\n"
    libexec.install "digdag-#{version}.jar" => "digdag.jar"
    chmod 0755, libexec/"digdag.jar"
    bin.install_symlink "#{libexec}/digdag.jar" => "digdag"
  end

  test do
    ENV.java_cache
    system "#{bin}/digdag", "--version"
  end
end
