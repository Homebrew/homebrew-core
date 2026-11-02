class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e927dabd0585bff1b4e040572e0ae59565c87fa86d239419aff623a34bceb757"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "743b890c42ed66bd7c149892fbe9c3b3d6c9053b7f38b222bcb1ef32581f0c6e"
    sha256 cellar: :any, arm64_tahoe:       "fd938d571f1d0511c7826c512ad405a5eb95e27905215929292c86b3d8d15de1"
    sha256 cellar: :any, arm64_sequoia:     "e24706b4167c0324048546e5923a056f15e2bbe1b6964407d98b1e46f83adfb6"
    sha256 cellar: :any, arm64_linux:       "a16df0169e36fd7f55232390109ffefc9914870efdd22165be1beefba973a604"
    sha256 cellar: :any, x86_64_linux:      "f3fc53df1e3fa843fb5a652c41aaf0774329cc66b15d39e2d2bfa99907210505"
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
