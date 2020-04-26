class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.10.742/cljs.jar"
  sha256 "4c003d7ccc4d6e49bd7a6b15dd7d0f1499df995715733def881374d8de0a70b9"
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
