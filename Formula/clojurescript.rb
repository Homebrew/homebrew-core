class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.10.758/cljs.jar"
  sha256 "dcc98e103d281d4eab21ca94fba11728e9f587c3aa09c8ffc3b96cff210adcce"
  head "https://github.com/clojure/clojurescript.git"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "cljs.jar"
    (bin/"cljsc").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/cljs.jar" "$@"
    EOS
  end

  def caveats
    <<~EOS
      This formula is useful if you need to use the ClojureScript compiler directly.
      For a more integrated workflow use Leiningen, Boot, or Maven.
    EOS
  end

  test do
    (testpath/"t.cljs").write <<~EOS
      (ns hello)
      (defn ^:export greet [n]
        (str "Hello " n))
    EOS

    system "#{bin}/cljsc", testpath/"t.cljs"
  end
end
