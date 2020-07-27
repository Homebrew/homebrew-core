class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.9.4.tar.gz"
  sha256 "be1b1e43c5376f2fdc8666aeb671df16c19776d5cfe64339292a3d35ce3a7faa"
  license "EPL-1.0"
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e65cbf112fe60434c3b6f748342de048feeaa63f10da2e26721ce9e83dea081" => :catalina
    sha256 "3e65cbf112fe60434c3b6f748342de048feeaa63f10da2e26721ce9e83dea081" => :mojave
    sha256 "3e65cbf112fe60434c3b6f748342de048feeaa63f10da2e26721ce9e83dea081" => :high_sierra
  end

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.9.4/leiningen-2.9.4-standalone.zip", using: :nounzip
    sha256 "0e3c339480347df0445317d329accbd4a578ebbd8d91e568e661feb1b388706c"
  end

  # Remove patch when updated to next release
  patch do
    url "https://github.com/technomancy/leiningen/commit/7677dabea40a2d17a42a718ca8c7e450b09e153c.patch?full_index=1"
    sha256 "91260bb1ce6974fe0134dfa46548a6083c0ae347c2acf8ef7e57b0adef8e8df2"
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
