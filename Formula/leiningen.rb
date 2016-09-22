class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.7.1.tar.gz"
  sha256 "953c95c2656c46320c88dc683202030fdd9554e8390a4b4aaaba6d019088df6f"
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b41705ff2d50650fd3bafa4bd19323b9cbecfef19a5c033bae069db6f36500" => :sierra
    sha256 "d058125ea615a7aeaf44515069e56176dd0cec6f51e59d8487c4b0e18e1245ea" => :el_capitan
    sha256 "03b41705ff2d50650fd3bafa4bd19323b9cbecfef19a5c033bae069db6f36500" => :yosemite
    sha256 "03b41705ff2d50650fd3bafa4bd19323b9cbecfef19a5c033bae069db6f36500" => :mavericks
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.7.1/leiningen-2.7.1-standalone.zip", using: :nounzip
    sha256 "2ddc7e89bbb45cf1ca3d666a10dce0d3f154b77ad201aa58f430e84e71587c47"
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

  def caveats; <<-EOS.undent
    Dependencies will be installed to:
      $HOME/.m2/repository
    To play around with Clojure run `lein repl` or `lein help`.
    EOS
  end

  test do
    ENV.java_cache

    (testpath/"project.clj").write <<-EOS.undent
      (defproject brew-test "1.0"
        :dependencies [[org.clojure/clojure "1.5.1"]])
    EOS
    (testpath/"src/brew_test/core.clj").write <<-EOS.undent
      (ns brew-test.core)
      (defn adds-two
        "I add two to a number"
        [x]
        (+ x 2))
    EOS
    (testpath/"test/brew_test/core_test.clj").write <<-EOS.undent
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
