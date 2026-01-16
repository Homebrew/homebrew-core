class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "https://boot-clj.github.io/"
  url "https://github.com/boot-clj/boot/releases/download/2.8.3/boot.jar"
  sha256 "31f001988f580456b55a9462d95a8bf8b439956906c8aca65d3656206aa42ec7"
  license "EPL-1.0"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5d6682e08bc0900b365f7f704190ed3358ff39d7d53cde67e813d79e69f28f2b"
  end

  depends_on "openjdk"

  def install
    libexec.install "boot.jar"
    (bin/"boot").write <<~SHELL
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      declare -a "options=($BOOT_JVM_OPTIONS)"
      exec "${JAVA_HOME}/bin/java" "${options[@]}" -Dboot.app.path="#{bin}/boot" -jar "#{libexec}/boot.jar" "$@"
    SHELL
  end

  test do
    system bin/"boot", "repl", "-e", "(System/exit 0)"
  end
end
