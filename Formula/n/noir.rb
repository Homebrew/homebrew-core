class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e568017b1a0daee51240fe2c9ef1edd538b96410af351256675195c28ffb7120"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca0698e19745e442c79c3949eef01ef53119214b5fb7bafcf1ee816d66b66d02"
    sha256 cellar: :any, arm64_sequoia: "2f248d389fe283ad00a65fe5917b63d7f0131dd31e31715e65ff2a6bc7358347"
    sha256 cellar: :any, arm64_sonoma:  "92d05dba307512af3912d6c88a1d1132b3df7e42698af653fcd96d04cb2ad12d"
    sha256 cellar: :any, sonoma:        "88b15cb2471f41da9f804bbd7e940a27e29ccd008e13302ec1b7bbaa8e37ac22"
    sha256 cellar: :any, arm64_linux:   "45950280e8fb0984ffdf9c1c214bb76764c5ccc8cbf7bfed829eea9e3a6901d4"
    sha256 cellar: :any, x86_64_linux:  "2bb7a9d13d991dc9a1a7eb2fe7d440af953f3ccc9e0e4a7e7a87c475e8031672"
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
