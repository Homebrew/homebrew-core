class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.8.2.tar.gz"
  sha256 "9abfbb112edb9c2181e6f8477f7b79c8a0768243fd0971f6491ed36952fd625b"
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d7ed18c03267aac7fe2e4790f075f9edd747329988f4993846a868cdd7a948a" => :mojave
    sha256 "e91bcbd0f1c06d42b91ff1c5e75173c467f719372dd98157a9bd7b898a3cb3d1" => :high_sierra
    sha256 "e91bcbd0f1c06d42b91ff1c5e75173c467f719372dd98157a9bd7b898a3cb3d1" => :sierra
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.8.2/leiningen-2.8.2-standalone.zip", :using => :nounzip
    sha256 "d7928dd1d336f1c04e095af068defee3c729011c8507686229755c91c230cb38"
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
