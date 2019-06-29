class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-tools-1.10.1.455.tar.gz"
  sha256 "d2ae0f890e857f27bcf00d1c06d203c925c97e6f75769ba1cac0199c93f432af"

  bottle :unneeded

  depends_on :java => "1.8+"
  depends_on "rlwrap"

  def install
    system "./install.sh", prefix
  end

  test do
    ENV["TERM"] = "xterm"
    system("#{bin}/clj -e nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
