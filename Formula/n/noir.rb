class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1ebd3e81cf9afc332bcc35eb871d5c8fb70704dd6bd4025aca14148a8bfbdf73"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7012c56b552f1559fe9f1af5b254eb54eab996640c8fd046534c8ac962f9c283"
    sha256 cellar: :any, arm64_sequoia: "e085cd689af4db4cc2c7a82c479b56fc7f0a2e92d617ad2c1f61f685c5a9835f"
    sha256 cellar: :any, arm64_sonoma:  "c50d724736eb3f8c3971b433d16192d631942816c2f38b02a251915fda3052d8"
    sha256 cellar: :any, sonoma:        "dfb47c5a42d67e7a8bc1e4605f06956edf74373bb16ef4c28a707c28b36d077b"
    sha256 cellar: :any, arm64_linux:   "17c394b41b0196577f058ac38574563f3338d6a06eda1813e6a1eb0941721e2d"
    sha256 cellar: :any, x86_64_linux:  "a8beb85f7e8f0a38f1cc2aaff57170f98a46831ce7a2aa05c760d786311e3201"
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
