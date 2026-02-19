class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.0.tar.gz"
  sha256 "2d9a04e6685508dc7615d7bab9d6be0699ae1a436a614ba364c2b292888bd9ef"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7dffd7c67db23ad6cc9bfbd590f9cec89870f19868605755ba418c1285343d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55ef0d7259408e23a4429366b874c8c88a81f52228bd621cdd0fa7f2a0805644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118dae329714ee5e9856490068224e18ba4a07628940c30360761eb3155ff066"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc1e16de269ea5650b0b6187c6adc4be75cf57f9470764de02a5fcafff7a1463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efe6ad4d70760af7d057832cf866e1c8b58b0f56d8dc6e2e7323599fed910aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7329fde35963f978fbeb661e17bb5a09a1ada71053ca3f574bbdf0c8ae9a065d"
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
