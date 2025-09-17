class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "bba94c7278b4e605c68ae73dbd3bb337a13c262718018b50e3b80affaf599407"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfb8daadc60f421da42f6689e281f1d4ad0593aa377ba8f53768b5e709076a49"
    sha256 cellar: :any,                 arm64_sequoia: "8726ec9ba560772679a5205b5272516ca1185a34fdf08c11d856364473ade38a"
    sha256 cellar: :any,                 arm64_sonoma:  "d1c64c50169ff4503c1aaf53075eef4636d4b024ee41457468cb5ad721663df6"
    sha256 cellar: :any,                 arm64_ventura: "91f5b9bcd3a92f4b04f63170e170e921c61146e452344838d1e7fbaa8014c0ac"
    sha256 cellar: :any,                 sonoma:        "5c1b22578088746394ac49fa7b8ecfb34eaeba5eafc93f1f542d74b564324896"
    sha256 cellar: :any,                 ventura:       "84a1288432f668921f85f81d224bf8c2e79ffa12af96332ddd0cac9c90a58623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b93cc1d2a9aaca02deeb4bcb51b0a2129c7efde57518d31783cadb658aed6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503be80f801e902dcdf316164ac1b7d4b84e98649f21b66efb8c808e0d88f207"
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
