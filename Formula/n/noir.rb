class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "d88ec9836e9d314a05bd5aff27759015af8f0897e16171b21fe1390785be64a3"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc19a051850f4e958ebb8c9d22539e64fd81a3b905ff13a74446984e7913956b"
    sha256 cellar: :any,                 arm64_sequoia: "1f1971dcb7f0aa7703680799d448632a96e9cb376f5c6662f5f977e3588c3dda"
    sha256 cellar: :any,                 arm64_sonoma:  "6b3b962d3fdd11530162c6db8f5a6cb1c7e8e219a5051283d03767a76090cdb2"
    sha256 cellar: :any,                 sonoma:        "92af5d10fc48fb241bf458b5bc894e92aac6dd0adc32984aa60a25bdf5221ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80abb14cf38e0903880a8ade1ec1d58e0879b0138cebf7adc0051f86a82f974d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3590f5571b8e9fa51909da488b449f14b59b056c9cfb091092454cf5cf60d2b5"
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
