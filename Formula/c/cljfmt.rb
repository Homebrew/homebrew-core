class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.15.6.tar.gz"
  sha256 "a64600778bd4e387253517df36d4bbd693d0c4f92be5d4290f35a0636653ed12"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6a43697a2a694e5d051756df398312dc92ef5e8a3043cb91094c9ed860fe89c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea1d78f4bfa95e74cb113995f6b16e540608523eaf6352b4aded9a98ab2c1cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f77a2d3ed93174c5b5a4d17a3ac7a01897adaffc21276f9370e13a2cf43f02e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e27637fd1f10880f9459eac52c7841e52821d5778f13f67695cdbe387191615"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147de0121f7817facf321f23b5037a056a8d8cde3d0dc251241aa21153bb3746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "496bab021627e8077e289930444b1c7a8622d5bb78953323fa30c85da409b4fa"
  end

  depends_on "leiningen" => :build
  depends_on "openjdk"

  def install
    cd "cljfmt" do
      system "lein", "uberjar"
      libexec.install "target/cljfmt-#{version}-standalone.jar" => "cljfmt.jar"
    end

    bin.write_jar_script libexec/"cljfmt.jar", "cljfmt"
  end

  test do
    (testpath/"test.clj").write <<~CLOJURE
      (ns test.core)
        (defn foo [] (println "hello"))
    CLOJURE

    system bin/"cljfmt", "fix", "--verbose", "test.clj"

    assert_equal <<~CLOJURE, (testpath/"test.clj").read
      (ns test.core)
      (defn foo [] (println "hello"))
    CLOJURE

    system bin/"cljfmt", "check", "test.clj"

    assert_match version.to_s, shell_output("#{bin}/cljfmt --version")
  end
end
