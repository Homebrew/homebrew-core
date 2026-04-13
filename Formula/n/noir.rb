class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "a7e3703d71acc0736effe71d3b7ee973ce0f49d03546501bd3e354f2bcf40065"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09deb3040aa035a7c48438f87e94fddd7bf3482f75dba8035214bab221e366f4"
    sha256 cellar: :any,                 arm64_sequoia: "a4da490d5f5db6398884ddf68edf1329a79022641dd064152d64b03f22cb2605"
    sha256 cellar: :any,                 arm64_sonoma:  "fd814218db44d32ed1e3e2dee26aa4205f16398690ca90f838078563fa72c92f"
    sha256 cellar: :any,                 sonoma:        "16c367765a4230a251d182e71fb90eea84d50495463a1306362890df3c9f26b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a886eae8cfad285aa9044167d379afeaec0730935009fdaa9cb93649b2fb53c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20f1fc248edbabcf6a7a2df91b1eeb9acd3f2220e01e34bfbd81e52cedc32a44"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

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

    output = shell_output("#{bin}/noir --no-color --base-path . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end
