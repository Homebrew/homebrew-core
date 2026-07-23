class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "15d3fa026f8dc69b12c5ac4d1b32735c6214eec42ae46c7b448ebec28f6a8714"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ae927eac5764dd6bb710d250eb4e5d5b3b40e587720902f04453df5d76c69810"
    sha256 cellar: :any, arm64_sequoia: "9135c1b68e09d32f36ebab4ca44060b35bdab57a24cc55727c24ed32446a90e8"
    sha256 cellar: :any, arm64_sonoma:  "4809a43937e0611d98c1c9c8133e5b006d126a674668b8840d79d62c831b012e"
    sha256 cellar: :any, sonoma:        "97509067af27fae70485cdc5ceec552b05d90bea486c339b770276d9ef060c8e"
    sha256 cellar: :any, arm64_linux:   "374c280de179e2e5dcd8464e41a6b506f45256716add6ff858ef4330de12a682"
    sha256 cellar: :any, x86_64_linux:  "61f6f09343108cee81de5c915978bf2a60fc6b8cfe255b1a056cad05a206dd2c"
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
