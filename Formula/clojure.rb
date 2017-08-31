class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/install-clj-1.8.0.122.tar.gz"
  sha256 "aca9fbda33a5b94553f7030ff745114f5d003babde47a7d66415c6108acc63ad"

  devel do
    url "https://download.clojure.org/install/brew/install-clj-1.9.0-alpha19.142.tar.gz"
    sha256 "288f84bd1f19e2fa3298c1bc9dd7b2b8a98aa0b7f0b2a99bced3ebe7b5450e45"
    version "1.9.0-alpha19.142"
  end

  bottle :unneeded

  depends_on :java => "1.7+"
  depends_on "rlwrap"

  def install
    prefix.install Dir["*.jar"]
    prefix.install "clj.props"
    inreplace "install-clj", /PREFIX/, prefix
    bin.install "install-clj"
    bin.install "clojure"
    bin.install "clj"
  end

  def caveats; <<-EOS.undent
      Run `clojure -h` to see Clojure runner options.
      Run `clj` for an interactive Clojure REPL.
    EOS
  end

  test do
    ENV.java_cache
    system("#{bin}/clj -e nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
