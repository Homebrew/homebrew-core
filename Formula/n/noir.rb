class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "4eb42ea48dd3efdfa393db9a99ef4f72463719fc1d29ac54a396cb4780617f64"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a349604723f7671f3b5a111a647d8cb6d1a54c3368be6afe9e1863c94e16dc33"
    sha256 cellar: :any,                 arm64_sequoia: "51240442cb1e8c9b8964d81024ead88668d4e47effb0cecd4cd408aeeaaae112"
    sha256 cellar: :any,                 arm64_sonoma:  "5643da797c82e5554b0d2a265fde9172ae1b890692b6e614069facd0f9e48e38"
    sha256 cellar: :any,                 sonoma:        "fbff8a8641c4e08ec0b0235218c738785994dee3034a60587a610a67bd3fab11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "685bde07b2af85134053cc916f7f4cad2f3bde934bdd82a5a4c3a34c618fca7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f321be39d87bc9e35f797e14949209a6113db00945454b0a86430afab90a34"
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
