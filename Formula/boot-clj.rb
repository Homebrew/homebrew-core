class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "https://boot-clj.com/"
  url "https://github.com/boot-clj/boot/releases/download/2.8.3/boot.jar"
  sha256 "31f001988f580456b55a9462d95a8bf8b439956906c8aca65d3656206aa42ec7"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "boot.jar"
    bin.write_jar_script libexec/"boot.jar", "boot"
  end

  test do
    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
