class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-tools-1.9.0.372.tar.gz"
  sha256 "2d1d54e72463ad735a7a5c2e49c2b0c17d21d7c989adc40116429386518160a8"

  bottle :unneeded

  depends_on :java => "1.8+"
  depends_on "rlwrap" => :recommended

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
