class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/refs/tags/2.12.0.tar.gz"
  sha256 "a190d92325b552621b1709a42a2cb78c74ffd795269f48e7619031e1127ad542"
  license "EPL-1.0"
  head "https://github.com/technomancy/leiningen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5e5aa03c54b6c0060b283f46a1ac092f5fcaf771804e714c0126472f4024dd8"
  end

  depends_on "openjdk"

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.12.0/leiningen-2.12.0-standalone.jar"
    sha256 "b721a573af631784f27ccb52e719e6d1287d9d3951ad56d316d38f7ecfa81aa2"

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
    (bin/"lein").write_env_script libexec/"bin/lein", Language::Java.overridable_java_home_env
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
