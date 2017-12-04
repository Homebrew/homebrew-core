class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-scripts-1.8.0.193.tar.gz"
  sha256 "82e671b252362e1bdff2d5ffc8b5ef758df29f4b6503b41a79ee646c8c2651e1"

  devel do
    url "https://download.clojure.org/install/clojure-scripts-1.9.0-RC2.263.tar.gz"
    sha256 "62ec95e45d78548cc3b7ecd81dee6a697f81a86768c996a2c199af1664083a86"
    version "1.9.0-RC2.263"
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
