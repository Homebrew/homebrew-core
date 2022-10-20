class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "https://boot-clj.github.io/"
  url "https://github.com/boot-clj/boot/releases/download/2.8.3/boot.jar"
  sha256 "31f001988f580456b55a9462d95a8bf8b439956906c8aca65d3656206aa42ec7"
  license "EPL-1.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e055fc4afde1c73066be6a183728ef6c714236c80b65af67723036d83c24041"
  end

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
