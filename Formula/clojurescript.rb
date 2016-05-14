class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.8.51/cljs.jar"
  version "1.8.51"
  sha256 "7f395466b631f1a0b9b90bd2cb44ae4a7a5f9b1f81c362e1900d35dc676209a9"
  head "https://github.com/clojure/clojurescript.git"

  bottle :unneeded

  def install
    libexec.install "cljs.jar"
    bin.write_jar_script libexec/"cljs.jar", "cljsc"
  end

  def caveats; <<-EOS.undent
    This formula is useful if you need to use the ClojureScript compiler directly.
    For a more integrated workflow, Leiningen with lein-cljsbuild is recommended.
    EOS
  end

  test do
    (testpath/"t.cljs").write <<-EOF.undent
    (ns hello)
    (defn ^:export greet [n]
      (str "Hello " n))
    EOF

    system "#{bin}/cljsc", testpath/"t.cljs"
  end
end
