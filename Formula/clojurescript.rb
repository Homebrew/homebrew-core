class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.9.946/cljs.jar"
  sha256 "b2aec435c8fa285bf75afe02f5c15ab041f92753bacd7570f637afa8eb63e854"
  head "https://github.com/clojure/clojurescript.git"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "cljs.jar"
    bin.write_jar_script libexec/"cljs.jar", "cljsc"
  end

  def caveats; <<~EOS
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
