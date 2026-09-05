class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "24a969227b9b5b8e3b9420ef00315761a9a91fd22936de52f1e94951c5016653"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b482fc3e28690c78b329c725cdd9d366ff2d2c659384345b67734caec73c6f5a"
    sha256 cellar: :any, arm64_sequoia: "e0a4365d097c186addafa20efbe78a2187c10bf6f95b611be5fb5d92685ff810"
    sha256 cellar: :any, arm64_sonoma:  "73bdf965e689dcaa097aa8be938fc572bda07329257a8daa6fb56d278dbf9974"
    sha256 cellar: :any, arm64_linux:   "8f9da9a00236c21fdc767f877fd113c3370e4183f8571b85b092c05d291d70d8"
    sha256 cellar: :any, x86_64_linux:  "f2b0adefa70187c1d1fd5f674289f5de725acb40f7c2ee5896edb9984a3f6ac5"
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

  deny_network_access!

  def fetch
    system "shards", "install", "--production", "--skip-postinstall"
  end

  def install
    system "shards", "build", *std_shards_args
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
