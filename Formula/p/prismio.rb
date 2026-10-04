class Prismio < Formula
  desc "Compiled, statically typed language with compiler-managed memory"
  homepage "https://prismio.org"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prismio-lang/prismio/releases/download/v0.1.0/prismio-0.1.0-macos-arm64.tar.gz"
      sha256 "57405fdb40a329a7afc418cd6ef3fa583dfca6268867ac030f183735425f8598"
    else
      odie "Prismio currently publishes macOS binaries for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prismio-lang/prismio/releases/download/v0.1.0/prismio-0.1.0-linux-arm64.tar.gz"
      sha256 "f3cd7ea606fe2a69ade10208529e72c82941c217b21959b1d634c5cdf17ddbf4"
    elsif Hardware::CPU.intel?
      url "https://github.com/prismio-lang/prismio/releases/download/v0.1.0/prismio-0.1.0-linux-x64.tar.gz"
      sha256 "9e4c11ca32bed81e1063fa03a5bf5f4ea8201a113040c51410185f57789a3230"
    else
      odie "Unsupported architecture: #{Hardware::CPU.arch}"
    end
  end

  def install
    archive = if File.directory?("bin") && File.directory?("lib") &&
                File.directory?("stdlib")
                "."
              else
                Dir["prismio-*"].find { |path| File.directory?(path) }
              end
    odie "release archive did not contain an extracted Prismio directory" unless archive

    bin.install "#{archive}/bin/prismio"
    lib.install "#{archive}/lib/runtime"
    lib.install "#{archive}/lib/runtime.hash"
    prefix.install "#{archive}/stdlib"
    prefix.install "#{archive}/LICENSE"
  end

  test do
    assert_match "prismio 0.1.0", shell_output("#{bin}/prismio --version")

    (testpath/"hello.psm").write <<~EOS
      import std.io

      fn main() -> Int {
          println("ok")
          return 0
      }
    EOS
    system bin/"prismio", "build", testpath/"hello.psm", "-o", testpath/"hello"
    assert_equal "ok\n", shell_output(testpath/"hello")
  end
end
