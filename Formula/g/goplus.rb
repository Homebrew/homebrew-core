class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.7.tar.gz"
  sha256 "312b8e72cf8ae933845459bd75683fd70d43c1fd57e757940e86d0a387821ecc"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "d0544b5466345294e0bada6202c89744393f33f4ef93b2afb49b5aa3ac51dfe8"
    sha256 arm64_monterey: "5680ce882b36ec919783c071420f50a465f1d95ecdd4dd0c40aa3cff49c95b31"
    sha256 arm64_big_sur:  "ff51a28464e6a5b934df97f1b42df14f0a4fa0f1a12a184d80fb3d5b2e2c6089"
    sha256 ventura:        "08eb8bb59b6f295c3f93480a6dd1643e7052428eeeec40509b5e0625344f3a11"
    sha256 monterey:       "150a07d2c1800acc2d68cd9e92debb40bd9305475a8adbd408323259c283d7f2"
    sha256 big_sur:        "e884d340b88b65c96d0dc7093d3f7dd6420f4825cd1d2c872d953914199a18ca"
    sha256 x86_64_linux:   "e89bec312a3d4b5cdebde7a263ddd44ca28829a272bced14b7ac3ec909f419a6"
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
