class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.35.tar.gz"
  sha256 "7af3b987046cadad45b091ddd7cdf5786ec3393ba5ab6471f53220d8b01932be"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "03bca4c377619faa3bdcba86e0a731e3819272bf11a2e91ac9d3d4464992c096"
    sha256 arm64_big_sur:  "ec1be340747565ea7ea20af78deedd398249d2b98372e162e62d4e3d1fe62789"
    sha256 monterey:       "48de3d03b8ad2bdaa23821cdc4a4c18032b4a54153551f808e9ccf9ea62b8325"
    sha256 big_sur:        "0b771374e79b3819f4d4ae57d7a951d9464b45959917d7527b2d0961ef37a08e"
    sha256 catalina:       "3c42d312fc1c2b7f7b64922c6af002da0197b9320db044fb1a2385af74357097"
    sha256 x86_64_linux:   "c7581896d8ce61acc929751a55bdeeb1535178e7a78bb5f6a0cfe3442cab27d3"
  end

  depends_on "go"

  def install
    # Patch version to match the version of gop, currently it get version from git tag
    inreplace "env/version.go", /^\tbuildVersion string$/, "\tbuildVersion string = \"v#{version}\"" unless build.head?

    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
