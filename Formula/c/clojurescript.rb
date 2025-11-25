class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.12.116/cljs.jar"
  sha256 "00bd2eeb5f43605ab15b9f0350be7d9ffad4ef72f31a9065b26a8c48439a245b"
  license "EPL-1.0"
  head "https://github.com/clojure/clojurescript.git", branch: "master"

  livecheck do
    url :stable
    regex(/r?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8616db1e52982fe64d5ef630e127e5c7038e55e3e11b8f00fa30f0d27f9bd58c"
  end

  depends_on "openjdk"

  def install
    libexec.install "cljs.jar"
    bin.write_jar_script libexec/"cljs.jar", "cljsc"
  end

  def caveats
    <<~EOS
      This formula is useful if you need to use the ClojureScript compiler directly.
      For a more integrated workflow use Leiningen, Boot, or Maven.
    EOS
  end

  test do
    (testpath/"t.cljs").write <<~CLOJURE
      (ns hello)
      (defn ^:export greet [n]
        (str "Hello " n))
    CLOJURE

    system bin/"cljsc", testpath/"t.cljs"
  end
end
