class Able < Formula
  desc "Able programming language interpreter"
  homepage "https://github.com/hofcoral/able"
  url "https://github.com/hofcoral/able/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "b7e20687f7e7c9339ce371da563b66a93d3a30a2350b4747fae377e3d9baa2b4"
  license "MIT"

  def install
    system "make", "CC=#{ENV.cc}"
    libexec.install "build/able_exe"
    libexec.install Dir["lib/*"]
    (bin/"able").write_env_script libexec/"able_exe", ABLEPATH: libexec
  end

  test do
    (testpath/"hello.abl").write("pr(1)\n")
    assert_equal "1\n", shell_output("#{bin}/able hello.abl")
  end
end
