class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/clojure-scripts-1.8.0.174.tar.gz"
  sha256 "15532d91fec9312139fec0cc24c6f4d7ff6a45ec00def204dc464705904ad56f"

  devel do
    url "https://download.clojure.org/install/brew/clojure-scripts-1.9.0-beta1.229.tar.gz"
    sha256 "e06771a617312acd1472767e2d23d192d9e0c6c2eaba9af95623e74fecd00163"
    version "1.9.0-beta1.229"
  end

  bottle :unneeded

  depends_on :java => "1.7+"
  depends_on "rlwrap"

  def install
    system "./install.sh", prefix
  end

  test do
    system("#{bin}/clj -e nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
