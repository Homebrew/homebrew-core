class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.6.tar.gz"
  sha256 "f993bfddf454f0ab07dd9f5dc6524a2639385ae7ba6b32b0a89c71077ce71fc7"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21ebf43190a4e4b09056fa2cdb074df9982bb265b3e0b3bc2ef4412dbb9ababa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d249a95ce20042eb921b8c9bbb92ad03a972fe4088bbe971736c755c970001eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81ffc6b9fc567661b82f095467c2aed4467f02a36817aba9470ed0e3fcb7d067"
    sha256 cellar: :any,                 arm64_linux:       "adfb571d200e55ee3ccf8d40d62164ceec9dd83c2658cace2ee1f20897ed9262"
    sha256 cellar: :any,                 x86_64_linux:      "c93dab5a9e271d164abd55206cb430c88a10219706a161f44650d104089af6ef"
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
