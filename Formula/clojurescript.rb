class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.10.891/cljs.jar"
  sha256 "91a43bedd850b509ab72f429e03916fef453c079c9c480a2392df76109027b32"
  license "EPL-1.0"
  head "https://github.com/clojure/clojurescript.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/r?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96f5fb870831289f84b565bc7fd72a75e59a0b234986c0077fac9b3665dc7235"
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
    (testpath/"t.cljs").write <<~EOS
      (ns hello)
      (defn ^:export greet [n]
        (str "Hello " n))
    EOS

    system "#{bin}/cljsc", testpath/"t.cljs"
  end
end
