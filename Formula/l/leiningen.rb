class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://codeberg.org/leiningen/leiningen"
  url "https://github.com/technomancy/leiningen/archive/refs/tags/2.13.0.tar.gz"
  sha256 "a71aaf44eaf7796198943bd6db7662c99664bb6441f8dc7216d4a87fa4ea4dad"
  license "EPL-1.0"
  head "https://github.com/technomancy/leiningen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2dd30cf30c1f139181469c5773596cb27eae48f667a7e2ff2710042800f889b6"
  end

  depends_on "openjdk"

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.13.0/leiningen-2.13.0-standalone.jar"
    sha256 "5f5231f06c3c7924e3241e3dfa52885577fb44ddf8a9ea373d2c5e2f27217565"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "jar resource needs to be updated" if build.stable? && version != resource("jar").version

    libexec.install resource("jar")
    jar = "leiningen-#{version}-standalone.jar"

    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexec/jar
    end

    (libexec/"bin").install "bin/lein-pkg" => "lein"
    (libexec/"bin/lein").chmod 0755

    # Leiningen resolves the JVM from JAVA_CMD, not JAVA_HOME; derive it so JAVA_HOME is respected
    # Issue ref: https://codeberg.org/leiningen/leiningen/issues/112
    java_home = Language::Java.java_home
    (bin/"lein").write_env_script libexec/"bin/lein",
      JAVA_HOME: "${JAVA_HOME:-#{java_home}}",
      JAVA_CMD:  "${JAVA_CMD:-${JAVA_HOME:-#{java_home}}/bin/java}"

    bash_completion.install "bash_completion.bash" => "lein"
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
    (testpath/"project.clj").write <<~CLOJURE
      (defproject brew-test "1.0"
        :dependencies [[org.clojure/clojure "1.10.3"]])
    CLOJURE

    (testpath/"src/brew_test/core.clj").write <<~CLOJURE
      (ns brew-test.core)
      (defn adds-two
        "I add two to a number"
        [x]
        (+ x 2))
    CLOJURE

    (testpath/"test/brew_test/core_test.clj").write <<~CLOJURE
      (ns brew-test.core-test
        (:require [clojure.test :refer :all]
                  [brew-test.core :as t]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (t/adds-two 2)))))
    CLOJURE

    system bin/"lein", "test"
  end
end
