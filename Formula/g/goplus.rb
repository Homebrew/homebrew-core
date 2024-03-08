class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "0e28ad347b39f151449ce1cb0ee17057491d8f9e6d34365367d9e2207e514309"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "88af8b3d885963c039a7ef66b7a972e208ce4c051d20c9b020a0cbbb8ee638c6"
    sha256 arm64_ventura:  "01852b16628d5a9ac4d28b1b926dcf47e39dd91df8eea000aa676d17d5f939e0"
    sha256 arm64_monterey: "505cd098044c54bf6d8235d845c0214e9b19c5d2f4df39c29379fd7b6e272a77"
    sha256 sonoma:         "7d4309592eeeafbedcfc4f7a845fcd8f8ae651046e500e10f8ad07c4ae5a9179"
    sha256 ventura:        "3606463415cac105af5164bc0fecc665473858a5e8e9528332bcfd1bce475494"
    sha256 monterey:       "a047a55488d346f7cf3c1405a737b1f14d4ad6aa0a20c47e103d8a7079381234"
    sha256 x86_64_linux:   "b3d1d62d334b783689af144e4b20640320738a1e69334de9a5f0b6abc57964a4"
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
