class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "da4f9fe2359164edacba9b485efcfe363c2ee00869ede54cb52abc9fe322961f"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ad73676db9d36cb3a0baf6fdd2f0b111fb4e76d0bcce1d92a83dec2ab2b38773"
    sha256 cellar: :any,                 arm64_sequoia: "8fbb13d6480a8c637ee4ac3b98de110f0840ec7b7ac1e11c7c56acca5ccb77fc"
    sha256 cellar: :any,                 arm64_sonoma:  "723c7d2a07427d0257432a3773caf39cc50a35079a8ba01688683301a4a4fe97"
    sha256 cellar: :any,                 sonoma:        "78658c7e805d60b2498781aaba920e989fe916923ae48d84e3c3f2e13de9faa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d28affa37f93bd3733c4eba37fc566cf19e194443677276be4cca17126471f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f80ff9fda228acefa522c694781c2d0af7517c03d1c835d18869df2c68c7b6"
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
