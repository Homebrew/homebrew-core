class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e927dabd0585bff1b4e040572e0ae59565c87fa86d239419aff623a34bceb757"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "157d2ae43c05442a23ef70517e3c0ea9af76793c8bbde62d7007dce4705c9d57"
    sha256 cellar: :any, arm64_tahoe:       "fed8a2f9a97392ec4010284078c665a58b02fd007ba79ac06d269978a10dc14c"
    sha256 cellar: :any, arm64_sequoia:     "44f296f43d069b157410b90cb11597b5fbfc673d599632d5deaf866094f9feff"
    sha256 cellar: :any, arm64_linux:       "5a19674ffe096c5ef32f04f9f4d432dab14423a2fa0d7f73af3a519cf03de768"
    sha256 cellar: :any, x86_64_linux:      "66423aefc545487bc92284e1323ff4e1d3a1584299803633ae33f700974665d8"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libyaml"
  depends_on "openssl@4"
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
