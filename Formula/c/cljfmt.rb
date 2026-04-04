class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.3.tar.gz"
  sha256 "31e0588f3db0f7f1a69cc4c4922d5686731ef9353fee4d15b0bcef05bf3fc86b"
  license "EPL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d441d82fcc778ff7aa68e14b694b441ae52e980803bad99f3cf473103581d4dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a1707a0c262ea634b8cb9b128b2998af073b16ad973b129067c535c5383c01e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82924449623b3b1a525828d09c35cb04108bd57be253cc9e8fe6826ebb8b9273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c415c412c4a7efbc239d3a2f41055578ce792e279fdac99b3bbfa7d33d185679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2187def5891156d64fee59d5497d91b0e6bac236611353ac8d74103cc4deed57"
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
