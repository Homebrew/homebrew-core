class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.0.32.tar.gz"
  sha256 "c008d6fcc8c8f3a08e69774a6e54dce82fae78414b6e5c45b5b619dd0572a139"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  depends_on "go"

  def install
    # Patch version to match the version of gop, currently it get version from git tag
    inreplace "env/version.go", /^\tbuildVersion string$/, "\tbuildVersion string = \"v#{version}\"" unless build.head?
    system "cat", "env/version.go"

    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/install.go", "--install"

    Dir["*"].each do |f|
      next if f.start_with?(".")

      libexec.install f
    end

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    cd testpath do
      ENV.prepend "GO111MODULE", "on"

      assert_equal "v#{version}", shell_output("#{bin/"gop"} env GOPVERSION").chomp unless build.head?

      system bin/"gop", "fmt", "hello.gop"

      assert_equal "Hello World\n", shell_output("#{bin/"gop"} run hello.gop")

      (testpath/"go.mod").write <<~EOS
        module hello
      EOS

      system "go", "get", "github.com/goplus/gop/builtin"
      system bin/"gop", "build", "-o", "hello"
      assert_equal "Hello World\n", shell_output("./hello")
    end
  end
end
