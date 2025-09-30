class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.13.4.tar.gz"
  sha256 "c8fcbedf9cbd6ea947bd72d31ba09bfae00a233106d6cfcbde09346260269d12"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c180b80ea917ca0f3184d52b2a1bd8f853fd9bc954109ff73ffee0bcc4ef3d75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ebcf7f2d1cc2e42694e71ca391498ffa0041a11e646506099cb44e6b6073c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33a24b99923384fb34fd380850a5bf5c308c148d42f611c79ca667a1c3f3ed6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "db109b87dbb6b7e1d9d55019890f6fa4d595e4e7e49f18cb27d1c76d7e59452f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea9f0042b3e1c1d7fce179e594613d3fed5ad42bd4f52adc33d71caba3a9cd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f48fcfd5e9072b0d9cef5a9b5e1a9cdc823abbb8d1ac6d6a76839b367d303bb"
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
