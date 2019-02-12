class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.9.0.tar.gz"
  sha256 "f90a846e99163d5b776764ba036a0017f83f545daae2d163c2f0c5fbbc71f0a5"
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2248b5d6cad9b54f2bdfa23167e8f9d6c0ed064930829aaea06c1fe615954c4b" => :mojave
    sha256 "08ae28f8244f0cb009b07ff81a89a37a6ac097933790f65182172a83fe3b2310" => :high_sierra
    sha256 "08ae28f8244f0cb009b07ff81a89a37a6ac097933790f65182172a83fe3b2310" => :sierra
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.9.0/leiningen-2.9.0-standalone.zip", :using => :nounzip
    sha256 "3566d7c5453cdf85d3bf7d77de44c12059aae5779db6e686a4839fc24541fc1e"
  end

  def install
    jar = "leiningen-#{version}-standalone.jar"
    resource("jar").stage do
      libexec.install "leiningen-#{version}-standalone.zip" => jar
    end

    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexec/jar
    end

    bin.install "bin/lein-pkg" => "lein"
    bash_completion.install "bash_completion.bash" => "lein-completion.bash"
    zsh_completion.install "zsh_completion.zsh" => "_lein"
  end

  def caveats; <<~EOS
    Dependencies will be installed to:
      $HOME/.m2/repository
    To play around with Clojure run `lein repl` or `lein help`.
  EOS
  end

  test do
    (testpath/"project.clj").write <<~EOS
      (defproject brew-test "1.0"
        :dependencies [[org.clojure/clojure "1.5.1"]])
    EOS
    (testpath/"src/brew_test/core.clj").write <<~EOS
      (ns brew-test.core)
      (defn adds-two
        "I add two to a number"
        [x]
        (+ x 2))
    EOS
    (testpath/"test/brew_test/core_test.clj").write <<~EOS
      (ns brew-test.core-test
        (:require [clojure.test :refer :all]
                  [brew-test.core :as t]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (t/adds-two 2)))))
    EOS
    system "#{bin}/lein", "test"
  end
end
