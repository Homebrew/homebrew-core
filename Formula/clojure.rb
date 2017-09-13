class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/clojure-scripts-1.8.0.135.tar.gz"
  sha256 "d0d7f7a3f7e7eb8a3d971a73261d8378b37150139c6b3dbe55353d15b18a3e0f"

  devel do
    url "https://download.clojure.org/install/brew/clojure-scripts-1.9.0-alpha20.176.tar.gz"
    sha256 "da9a4670213e89086c246b9d26576b9f874a478523f0dbe3ca379633edd0a2e2"
    version "1.9.0-alpha20.176"
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
