class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.5.tar.gz"
  sha256 "9f01984cefbd61f469811158c5ec86ea7722a483c98a265ecefbbb754175cb2d"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d64ed860312ee28a5a7fdf269d063e65f7e9b951bd0968c2c0db5a886f1d23a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81012873b020e6c9c2af123c1fa5ddd6553512278a1cbee055ff1b06bcdfca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6059f16fa6c36d7c902d35839865b91f81d5a5ff36785fef945e166050a7608e"
    sha256 cellar: :any,                 arm64_linux:   "b0920aa961f83c66af916216f3c4bf0bc064237a8b2f4910ce109c7c23e796e2"
    sha256 cellar: :any,                 x86_64_linux:  "66548e700295ec8fdf8581da3a78795b3e139a6339b17d116596a65b3e515822"
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
