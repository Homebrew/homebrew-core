class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "6ec985a2e2ae3a37ed8f3126ec938ae74beecbaba80ab8e61d449ac65b08b8a2"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81663c60a678b01581fd89a6223cc7e54cd8d48133f5e8ed731ff837de1f580e"
    sha256 cellar: :any,                 arm64_sonoma:  "f69291a56d689be070db28f9e51562bac79ec90f4474081e79a8502248cbeab9"
    sha256 cellar: :any,                 arm64_ventura: "c06bb74abc335932be17b35a7a1ac029831311e91e1bf1e819a51e958fe96a27"
    sha256 cellar: :any,                 sonoma:        "bdc56a249561db5dc7b757b530c8983a1a8262cebf6988c5c3fe54ed2249e181"
    sha256 cellar: :any,                 ventura:       "3bb07f4bfcce918e0a34d4aadf5fccfcc45a1c1bbd7a1c79f3341daa579ef1e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81111e451b97d17c907f375e2889e66fdccb503b218808625969b36f3fc433c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df939a35f28fa76a58224f3189fa645ab7372acd118118e97f64b531a5fa0b4"
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
