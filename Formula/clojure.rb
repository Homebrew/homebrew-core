class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/install-clj-1.8.0.119.tar.gz"
  sha256 "7e272d3ae13d97c8fb6848d6851112e88995958391f40a1787bd82b6222d779e"

  devel do
    url "https://download.clojure.org/install/brew/install-clj-1.9.0-alpha18.125.tar.gz"
    sha256 "393c2f6025553376aebceaf359af08a9152edb9854ccc099460b06cf8dac1c5f"
    version "1.9.0-alpha18.125"
  end

  bottle :unneeded

  depends_on :java => "1.7+"
  depends_on "rlwrap"

  def install
    prefix.install Dir["*.jar"]
    prefix.install "clj.props"
    inreplace "install-clj", /PREFIX/, prefix
    bin.install "install-clj"
    bin.install "clj"
  end

  test do
    ENV.java_cache
    system "#{bin}/clj", "-e", "nil"
  end
end
