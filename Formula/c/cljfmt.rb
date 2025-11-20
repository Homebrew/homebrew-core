class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.15.5.tar.gz"
  sha256 "abc5c725172508b3f5b00f3adbbfdf77e29c8381a8d8d300203d9887372bea27"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12bf94248f9eaf4b2ae860ee55a3b381ab1c4b08d075ca707e513cfd4328d597"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a84a081bec382f135f1b23e2d57dc3c0ca8368123bfd7327362eac535abd552"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d71c740b08f3f6a8b6bdd88fe1fd21f156cc8cbcfa8c84beaf64bfdfdff4a5d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c41b4e1197871e2de4690714e6e29e2a702f43085d9920f166881382ca46ec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e9c4cb595e0e3f2d46c478bf527999e7d1186f0ec3e8bb98903a363ea39e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab549e0ba7e71d0577df110b72d92887a5014cec3161599d379b460b45776eb"
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
