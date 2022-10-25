class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.11.60/cljs.jar"
  sha256 "db13c578cbe9bc4ac12f62856db731da231710da2fb2b93eddbb9b9eda7bf2d7"
  license "EPL-1.0"
  head "https://github.com/clojure/clojurescript.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/r?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2748feab333c8d593dc9395c6a546ebeec6d7a9691ba5b0fa179e94dd0f8d6a0"
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
