class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.9.8.tar.gz"
  sha256 "be299cbd70693213c6887f931327fb9df3bd54930a521d0fc88bea04d55c5cd4"
  license "EPL-1.0"
  head "https://github.com/technomancy/leiningen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b223d9b801258547b2c6990b84f64f64f11a3ac89d774b2a4ef52c8df47ef4da"
  end

  depends_on "openjdk"

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.9.8/leiningen-2.9.8-standalone.jar"
    sha256 "2a0e9114e0d623c748a9ade5d72b54128b31b5ddb13f51b04c533f104bb0c48d"
  end

  def install
    libexec.install resource("jar")
    jar = "leiningen-#{version}-standalone.jar"

    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexec/jar
    end

    (libexec/"bin").install "bin/lein-pkg" => "lein"
    (libexec/"bin/lein").chmod 0755
    (bin/"lein").write_env_script libexec/"bin/lein", Language::Java.overridable_java_home_env
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
        :dependencies [[org.clojure/clojure "1.10.3"]])
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
