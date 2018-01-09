class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/clojure-tools-1.9.0.302.tar.gz"
  sha256 "6a1fdc44f8cc38ca668d926a448e8213d280708dcf10a4a0485f5f743fa6de86"

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
