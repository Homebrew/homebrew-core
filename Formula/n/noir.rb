class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "509ae0eaa1ef5c44bfa87533e1711963553b2185e1e5160ca02f85674ccc2935"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "239353d6b01327558a1a7e8d7e10d7b9b1925f8ea8d797c9740bf41978cb8aa8"
    sha256 cellar: :any,                 arm64_sequoia: "00e65278b5b0edc620aefa30282d9ebbbdcbc961279f2c7ffdbd404902d4c1c9"
    sha256 cellar: :any,                 arm64_sonoma:  "6ad544e8c5b8cb7dcb99b71b0ab79f3365d9fe62e8295b79b216bcfd5500e672"
    sha256 cellar: :any,                 sonoma:        "bec0cab1b2603d590958914491bf309b7cb441206005059d844bdb1844ecd4c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad2734ac573fb981499117af29697777152dbbeaaa4dd2726804dcabe0f5699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "785dc7a30d1b245e128578df1b363ffd93da7bc9966bc358fcb5eddf64439aeb"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    bin.install "bin/noir"

    generate_completions_from_executable(bin/"noir", "--generate-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    (testpath/"api.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("/hello")
      def hello():
          return {"Hello": "World"}
    PYTHON

    output = shell_output("#{bin}/noir scan --no-color . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end
