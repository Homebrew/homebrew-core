class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/owasp-noir/noir"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "c84023c119c9f497727f4840f0b57fbed09ccbec7731693e8603f4e766f64b8a"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c98913ef3a41a46a0d641e9267f8ec0ef63c1d3837690ea454178e634249f7f"
    sha256 cellar: :any,                 arm64_sonoma:  "dc61394b7468b85a9201a3dc9dc9fa6a0c27d4c02d963a053ad5c072812a1bf8"
    sha256 cellar: :any,                 arm64_ventura: "634ffc18aaf5f62b3e486c96c0f56c719aa68b2009c8b663010b6ed2ac1ce239"
    sha256 cellar: :any,                 sonoma:        "cd9f9d6e82177a650aff9c4b1c7148d69f60305a27a9ec173b986042a9324f5a"
    sha256 cellar: :any,                 ventura:       "0abc3373e854213509d3826948c80e315e1533c3761ea5bd631dff2aae49b628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097214353e24708038cd81057b1504285e48895027661ae7acafa3a470572e12"
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
