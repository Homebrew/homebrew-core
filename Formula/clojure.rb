class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/clojure-scripts-1.8.0.190.tar.gz"
  sha256 "8dc36eb4a720c65b1a284e4d838ea5ce30b4bae4640bfb526aa6ea785814fb9c"

  devel do
    url "https://download.clojure.org/install/brew/clojure-scripts-1.9.0-RC1.257.tar.gz"
    sha256 "064c9d09448beb7fc4b1027d893cff43a6319a441db3dc5da8737258e4c39805"
    version "1.9.0-RC1.257"
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
