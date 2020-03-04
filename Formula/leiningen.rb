class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.9.2.tar.gz"
  sha256 "da49422cef0bd2df58421d291ce948addd1ddad36e1c59487c3c6ff3b85cfa18"
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ec0dc556705e45e938a5c948b8741f3725a7230b5956cc7c13548f90848808e" => :catalina
    sha256 "4ec0dc556705e45e938a5c948b8741f3725a7230b5956cc7c13548f90848808e" => :mojave
    sha256 "4ec0dc556705e45e938a5c948b8741f3725a7230b5956cc7c13548f90848808e" => :high_sierra
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.9.2/leiningen-2.9.2-standalone.zip", :using => :nounzip
    sha256 "09805bd809656794cfe7d9155fd4b8bea2646092318690bf68e3c379574a2d3c"
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
