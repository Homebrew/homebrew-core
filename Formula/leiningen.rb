class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.9.7.tar.gz"
  sha256 "ab2bae41dde4b5abbf34db00f7c3cca592ed73c38e831aaf31c942bbe4e18d34"
  license "EPL-1.0"
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df641c65df341caa49d31b82e2f41c754f9b4bea31d104a4af7236d9ec7a8463"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6a3bca012d22ac2bfd31f2d63e1205f3e8b14a1a9c273efc4b812233adc1920"
    sha256 cellar: :any_skip_relocation, catalina:      "c6a3bca012d22ac2bfd31f2d63e1205f3e8b14a1a9c273efc4b812233adc1920"
    sha256 cellar: :any_skip_relocation, mojave:        "d144459a1bff33c0adbc0de79e97135be0b6fd768a3a7468f5ad484a3c1486f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0a514ea1a62334532c988bd8d633c65655279073dd80ab8beac826d7dccec4"
  end

  depends_on "openjdk"

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.9.7/leiningen-2.9.7-standalone.jar"
    sha256 "82f01414acecddbb0ebd6d571505bb671a6fd093236bcdac2468cfe5f2eaa802"
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
