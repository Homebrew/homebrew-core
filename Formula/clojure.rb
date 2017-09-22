class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/clojure-scripts-1.8.0.171.tar.gz"
  sha256 "fa53481e6f5998f2f0dd38ec3d67383e1c8fe05ffdfeff92d677b1bc32a4087c"

  devel do
    url "https://download.clojure.org/install/brew/clojure-scripts-1.9.0-beta1.225.tar.gz"
    sha256 "dc505f7ca36979a6c3fdc5819e8c46c52476477af1cb6d2f70440e92a8c022f2"
    version "1.9.0-beta1.225"
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
