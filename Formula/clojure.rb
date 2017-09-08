class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  url "https://download.clojure.org/install/brew/clojure-scripts-1.8.0.132.tar.gz"
  sha256 "9e544c830977aa796c750737f2fcee5e8f4be08c081493b9851c4bbb07c7e570"

  devel do
    url "https://download.clojure.org/install/brew/clojure-scripts-1.9.0-alpha19.171.tar.gz"
    sha256 "17241651fafa426c67a79099ea422645c0bc6ad5fc026bc183762518ec9bc9b5"
    version "1.9.0-alpha19.171"
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
