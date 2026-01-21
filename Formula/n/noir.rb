class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "e8a4838f811acda647bf0958ea1f5ee5fdf83fc6cecb81f59964cc87794ad204"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0cb9b4dba1d5a8b221949f7e7997d38611fd77552397aaf3df2f61dec20eecf5"
    sha256 cellar: :any,                 arm64_sequoia: "ffdda9deb3ef41da80fb98b551b754b62c6c6676bfc7268266f0f848e6a2b5cb"
    sha256 cellar: :any,                 arm64_sonoma:  "f6749ed81a9947fa82f70b114c98de4848a8dd3cd89638345e913513fb578ecf"
    sha256 cellar: :any,                 sonoma:        "1cb79b71fe934cbfdda6f7ca360e70137ded89bc1c8dea49ea55506170764069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aaa01b5cc8c1717199784abfa1f06404b17c41a0228e3186fd9d1df050a74dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f4f62e018ed1c6cdfc9012739f54ea6b209e5dc79ac73b8410f18bdc013a5f"
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
