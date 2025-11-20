class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "37861d7c498ddced48c4de6c06784f0dd5e9a733a12793064e1f3bcd40d77ca3"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5fac34fb782015fb2e8a7aa660ad1491bae5ba947e93df773af2c4d68f73b64"
    sha256 cellar: :any,                 arm64_sequoia: "f246f6ab8efda0add324075ecdfa291ed7160c07d6464a1ad9c51963d04c7992"
    sha256 cellar: :any,                 arm64_sonoma:  "1e9bfca3b5677797c5c19bbda9137c7d0b378cdf1bf0afdc5d6d6565a453962c"
    sha256 cellar: :any,                 sonoma:        "7e35b46c8d30201ffde5196d87ef6530013e90c0a32aed30548e6aa4762fca84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a6b79d02902923ccdf0062fb9af0ea1466329594aedd29872fc2a9f396f575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37328266457e1b82902681eb3032540a20942f1f18183eaa0573369b4da747aa"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

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

    output = shell_output("#{bin}/noir --no-color --base-path . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end
