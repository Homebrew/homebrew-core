class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/clojure-scripts-1.8.0.179.tar.gz"
  sha256 "38368bf8574ab7545ccfa7be7589a49007cc6865eae3f8d3a308298952ce649b"

  devel do
    url "https://download.clojure.org/install/brew/clojure-scripts-1.9.0-beta3.240.tar.gz"
    sha256 "e1e711f4c4ba1956099901e85db81a74bdbe5579366aa3fca936499a7d176c8b"
    version "1.9.0-beta3.240"
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
