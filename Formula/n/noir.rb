class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "378074556c31902c8db5d400e5be7cb0cee2bc223ac64ab88d381d5f9772e046"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b5a6a842c5f4ae0628d686a9966c5415ef9deda5a138b217a5597bab5fdfd5d"
    sha256 cellar: :any,                 arm64_sonoma:  "66c2f471904e9893c411a1241f38ba348e8342d7cea57586bfb5444fbd7e0e60"
    sha256 cellar: :any,                 arm64_ventura: "c40d0585aa4035aaff8a090dce87add09dacfd31777aa8add43ec6abea92130f"
    sha256 cellar: :any,                 sonoma:        "5ac7dad66053613b84a5a241ffd3411c7c7ab7081d63ed6182b2b851c4889bf1"
    sha256 cellar: :any,                 ventura:       "081ce4e39b7c104804aec07dc5111cc0af483afcab1f00ffd83eb2757cb9d685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4a21ac3352a72449b2158f1b1d530e7420fed8423a5d08a435a5676ef40d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6aa1ac39ad9e1dd29686452fba106f50b2b268fe717014a57635fe331bdfe4"
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
