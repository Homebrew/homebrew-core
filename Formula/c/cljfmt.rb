class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.13.0.tar.gz"
  sha256 "c5d646ac66bf059a032093a6e02bb10d9708d304de178bba42dcbb4119514361"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee2a5afc54b8a5672ac201554c83a3385ed4ebe368f691e43f53e2c3985e328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631a936578bf191ae7b31d5d189714c78d6442e7108327a528178628b3329677"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50f4081bb32838491dcb65ef9b7cdb2add762058e50f57fdad550f05596e4ac9"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd025dd7d09de7ef107ebe4a2c45f21a555fda1e2d400a55c64f64231f157357"
    sha256 cellar: :any_skip_relocation, ventura:       "b30d786b75af924518e992817a11bda8592e3c4b5a85365a95e22fd720c2498f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e70919c21b1b7be1814c6ee3d4f7255f6d5194e456de5be43ce70e10a66e94c6"
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
