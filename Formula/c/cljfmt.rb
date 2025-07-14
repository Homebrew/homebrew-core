class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.13.1.tar.gz"
  sha256 "d9deca44683cbb8b81153ea596d1cffe2451ff59b39fcf654971bded96641000"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b964ad8d5e233c888edc770ca27528ea6f697059abda7af11f74ac32677b04b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811039897680bffd757c679d3f2183be7a35041fb9d4f891d4439053c8c997ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1552894debdafa2fdadf2e0e8ec9f8a64a90e82a50f54100677d820960eb6d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "36896f538789940b786ff5120e6ea81bae30578d9263075f9b79b79897b540af"
    sha256 cellar: :any_skip_relocation, ventura:       "345222cf55c7aed887feb228db0aae01a59a08404463de0f37543b3f85993fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac4bfd96142ef6b39f323bda62f39d6e9fde7fb7669d6ddf1c852a9dfdeca030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa05bf1d4d121ac459123480eb198022e50af5ef98b8ac25c54692ca1cce43a3"
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
