class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.3.tar.gz"
  sha256 "31e0588f3db0f7f1a69cc4c4922d5686731ef9353fee4d15b0bcef05bf3fc86b"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8abd34902376fc90c868478bea6311345bf74327cd9816313eb1382625e14ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec601d9de6e7621489b3141990a3fbd775bb7651d01895e10e6134938170b8d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4ab707446d3cd0d21473806a8f99d39da8f0286941a0ef8b98bbd6ce090362"
    sha256 cellar: :any_skip_relocation, sonoma:        "c55ad099cc4bca60ef9744bfcd7ab3ba61c8dc89f525a0700a0767b718f06a8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009dd1dfc3765bb1ba2de3c4e7d31104cfeeb4aec598f69c69a9308722348ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37dc11b9b454cc8d8293fc74194dd07c89066b6913237eb8d6bf1fac006448f1"
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
