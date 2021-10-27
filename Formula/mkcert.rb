class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.4.3.tar.gz"
  sha256 "eaaf25bf7f6e047dc4da4533cdd5780c143a34f076f3a8096c570ac75a9225d9"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c57172b7216c9f78e41486251bf13acad21742da101793b10b6e6f69f9bf5c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "053f02796ab0165faaabc470cc161559d3ba5062b5e56f6df1bbd46a828f4991"
    sha256 cellar: :any_skip_relocation, monterey:       "5cf785059a301673a09850b1349afc0a799828e57eaec2e6423dbba75606da51"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dc2370651718c72f2484c81a6dd5813cb7fcf6a5ec6bb1bee94e1720d23d412"
    sha256 cellar: :any_skip_relocation, catalina:       "92ac9e87e65741d1cadb0372b259291dcd726fe1048715cfc993053cb62273e1"
    sha256 cellar: :any_skip_relocation, mojave:         "49c14e8620ffb1dc44d587eea2a6c329bac516f24d209d08b656b0c21af4e3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d0c2399c57a86fdcd2c46b043cf29ed9e7636dc0320dcbedcee1b8a30a125f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=v#{version}"
  end

  test do
    ENV["CAROOT"] = testpath
    system bin/"mkcert", "brew.test"
    assert_predicate testpath/"brew.test.pem", :exist?
    assert_predicate testpath/"brew.test-key.pem", :exist?
    output = (testpath/"brew.test.pem").read
    assert_match "-----BEGIN CERTIFICATE-----", output
    output = (testpath/"brew.test-key.pem").read
    assert_match "-----BEGIN PRIVATE KEY-----", output
  end
end
