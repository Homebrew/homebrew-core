class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/clojure-scripts-1.8.0.129.tar.gz"
  sha256 "8010fce3a9f7be929e82d3175dc6222a9080743e637af31ff7bf4179df5c797b"

  devel do
    url "https://download.clojure.org/install/brew/clojure-scripts-1.9.0-alpha19.155.tar.gz"
    sha256 "7c0a65755fb9e8341c6d5814525e09264ed4e460d63eae8096138be4fd6037c3"
    version "1.9.0-alpha19.155"
  end

  bottle :unneeded

  depends_on :java => "1.7+"
  depends_on "rlwrap"

  def install
    prefix.install Dir["*.jar"]
    prefix.install "deps.edn"
    inreplace "clojure", /PREFIX/, prefix
    bin.install "clojure"
    bin.install "clj"
  end

  def caveats; <<-EOS.undent
      Run `clojure -h` to see Clojure runner options.
      Run `clj` for an interactive Clojure REPL.
    EOS
  end

  test do
    system("#{bin}/clj -e nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
