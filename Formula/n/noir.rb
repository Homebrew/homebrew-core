class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "2480e0d61b4d8670f2a7665f93038f37277e15ab19b4f307418f047929c0349f"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "786f6890a9f48b96282a21074229be3343adae3ac4a174b679eae1bcd358a3b8"
    sha256 cellar: :any,                 arm64_sequoia: "72a5748a5c8f233c47b982f6d064e6190e2c726c87b4522d818c0a64a3cafff5"
    sha256 cellar: :any,                 arm64_sonoma:  "f1de46698eb8af4e5cab9c167719d93df57b34ac5cd217a891eedc5474344ad5"
    sha256 cellar: :any,                 sonoma:        "87602a0ecb5cf147c2734a36c79a02b8823942a05c248bff4c915363b8fe4e8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "467fa1a03ebe71e401b510d32b27189220177470a48476086f66153896a9be0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f62c4495f939d65315e63fbe46e57db3fbd359b4ebf4d7c3d698568e42402764"
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
