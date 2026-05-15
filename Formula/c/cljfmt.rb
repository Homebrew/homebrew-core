class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.4.tar.gz"
  sha256 "78f15de8726792f606f35c01bf9cb2b266e95f51938751335163f0d16404c56c"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa43d77791fcb0adde469c62c800dd0808182ab27e9ec1a381eac870f0a39edb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fd6b4add6f1369a63ebd72dcfa756aeab782b75003cbcb6ad1ea2f73d8c72c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f13324c55eb5da451a20a19e401ed3dca3ed2bb920ab95431eb8e45faeae74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bfc5e49d040f1261c9c7ad4f8d6a29a66f451572483804260ec0907ce41ee82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd711421832d54ceb1cc4e7a8b419da0077749c294e18e3a62f5bda9e720fec"
  end

  depends_on "graalvm" => :build
  depends_on "leiningen" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    native_image_env = ENV.keys.grep(/^HOMEBREW_/).map { |key| "-E#{key}" }
    ENV.prepend "NATIVE_IMAGE_OPTIONS", native_image_env.join(" ")

    cd "cljfmt" do
      system "lein", "native-image"
      bin.install "target/cljfmt"
    end
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
