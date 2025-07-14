class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "9e4f2e58ff9920df4f690829c3a30707549b9e4c5d719abfb0c092d6fe5e073e"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f07a47ee6cba9882fefd64ec929c2fab0db6236de7df0f156396272854a1270"
    sha256 cellar: :any,                 arm64_sonoma:  "109cbac29ea58cac8cbfaf0f0d9b57cb567dff7acc3f82cdd4c6658121bceb76"
    sha256 cellar: :any,                 arm64_ventura: "7e6666c5a26730f5f9980922e0fc3ee58117a5aee7f4d09b75874301d39e7131"
    sha256 cellar: :any,                 sonoma:        "d4b4c2deb9a9355638451b07a79851de9d0a4728192833a70ba9753928a9d513"
    sha256 cellar: :any,                 ventura:       "911fa0aa3672a965af96c4f83e46a1b4670225a64a0704eda3cce991c30eb489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "573e6c05bc6a6e9b6f52ee9139289a003c7a3f012ec869093c94d650959a1956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a2ef22e85532b56f587a18d89da0db54cfe2e6af8d008ae7c1ca2d753a33647"
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
