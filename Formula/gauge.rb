class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.6.tar.gz"
  sha256 "89b47749ef134e57295849e89a10fadf577e05aeb690e9db013c39e9c59b1f5d"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55748117bc55056a48b5c7b25071fd7b1a620361939f7016e2511d9b8eab2537" => :catalina
    sha256 "45b496b39ee682a95ca49b36a94e8041e03fca3644e80223c36539f495fee384" => :mojave
    sha256 "60af1c02f5a733bcb8614fe8bc2c7031675cde58aed3f6b0eb0a5a18602c8320" => :high_sierra
    sha256 "591e0cbb2faa78e291cc2dc026fe68532c6c63f4329fada91bdedc3695f92d00" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir
    cd dir do
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
