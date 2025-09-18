class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.13.3.tar.gz"
  sha256 "cadd1c3503a334cf1bb0fa586d5cae7ae5faa964329e945cd36cd9b01665f2a6"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f2056ba6795d38a97c45e3daaab06c96a204ff78da97b732b7ef82ac4468379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3817b052901c09ddd308f30b5150f69923b0d2f77a44b52e83405aa8b74e71f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0374ab1d3453e931e24379cf67b598135a74bcfae32a7f42203a2b061b93f7ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b5c2e398f0f2f4b1a3988bbbbeb6cbe4a766aa42345e39e403323ccb225ec2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df9e74ab08fdb8b0ac822354fcd65ecaa93f080f721035242219b956ce54d7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ec589d3ed8923e3401cef597a51a560d4b26699aace7a5bf8bb1863040006c"
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
