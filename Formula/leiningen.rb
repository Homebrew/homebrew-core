class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.9.3.tar.gz"
  sha256 "98cc1e58ebe0d71fede73ae6c7699f1b9b944650d57a220e576bc95a3185b846"
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ec0dc556705e45e938a5c948b8741f3725a7230b5956cc7c13548f90848808e" => :catalina
    sha256 "4ec0dc556705e45e938a5c948b8741f3725a7230b5956cc7c13548f90848808e" => :mojave
    sha256 "4ec0dc556705e45e938a5c948b8741f3725a7230b5956cc7c13548f90848808e" => :high_sierra
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.9.3/leiningen-2.9.3-standalone.zip", :using => :nounzip
    sha256 "23e1df18bc97226d570f47335a8d543e1b759ea303544ea57d5309be3dedcbbb"
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

  def caveats
    <<~EOS
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
