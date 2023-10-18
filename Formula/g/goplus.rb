class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.8.tar.gz"
  sha256 "7d5ebcb8090a76011374d049998f684462c0effd3abf32a32f857e69e8c93ce5"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "1d90729913311e1144a26832b862f868af314e15933aa0cf4949cab282870024"
    sha256 arm64_ventura:  "c14fb55724df3de0dd7437c1d7a9bb4c113a95eff1f1ac541787e274d82ff23d"
    sha256 arm64_monterey: "aaf819b6c2ac176cee05854093db10e20cd2f9b81ff2c02ac834c51df35bca4f"
    sha256 sonoma:         "68999a978746653ad63430a4bf8fada533506cb1cd0f33781624d97c2eeb8b78"
    sha256 ventura:        "8bbb3fe70488970061b79147d54aede732ed6de2a3f5c5c15ebf4865b65a32f6"
    sha256 monterey:       "be6a74a5f743eabd40536b6b4327eb61825f03abb56d6169ec450c896a8228cb"
    sha256 x86_64_linux:   "17e389bcbf6a408c597223d37cc830890886850791b7cdb981d698eae82e68e6"
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
