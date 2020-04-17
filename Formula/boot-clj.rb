class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "https://boot-clj.com/"
  url "https://github.com/boot-clj/boot/releases/download/2.8.3/boot.jar"
  sha256 "31f001988f580456b55a9462d95a8bf8b439956906c8aca65d3656206aa42ec7"
  revision 2

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "boot.jar"
    (bin/"boot").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      declare -a "options=($BOOT_JVM_OPTIONS)"
      exec "${JAVA_HOME}/bin/java" "${options[@]}" -Dboot.app.path="#{bin}/boot" -jar "#{libexec}/boot.jar" "$@"
    EOS
  end

  test do
    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
