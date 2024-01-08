class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.2.0-pre.1.tar.gz"
  sha256 "84e8a8e4bc4a82d97be2537406290fa0deebc5432eaf9983d25649e5f9f1deac"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "6cc87471a11edd69c1c099cbf359786fd4b04a38719c1b6b13f053c1d03f2211"
    sha256 arm64_ventura:  "d50e693afc85ed97189a240c4006e11122d7127b91c8a79d14c232e451f7805a"
    sha256 arm64_monterey: "8987cdde1c8a92c1b2655f739606f0b656943e001c8df754d6b434143cffc68e"
    sha256 sonoma:         "7369ae212e253d77d5e1f58c950475c19449dfa53ee3fe7e864751c7df31569e"
    sha256 ventura:        "cef2c0844eb72a8d6b8e78002e04b85dfad4f6850b3b2857fcc4a6537c434ecf"
    sha256 monterey:       "b950f6f52965541203f2ea23ae4f2c4477e11b76208cad944e0a04ea192b2eef"
    sha256 x86_64_linux:   "e4625e9a14863e9aeb466c985f3eafc1293088eefbada06fa18abd4d015ef429"
  end

  depends_on "go"

  def install
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
