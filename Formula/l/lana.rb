class Lana < Formula
  desc "Verified register-based language with explicit uncertainty"
  homepage "https://github.com/oponite/lana"
  url "https://github.com/oponite/lana/releases/download/v1.1.1/lana-1.1.1-source.tar.gz"
  sha256 "680a67b46378aa145175bb480cd4ddc4af10837454b41b8135cbf446e8a916f3"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"
    libexec.install bin/"lana-compiler.labc"
    (bin/"lana").rename bin/"lana-bin"
    (bin/"lana").write <<~EOS
      #!/bin/sh
      export LANA_COMPILER_LABC="#{libexec}/lana-compiler.labc"
      exec "#{bin}/lana-bin" "$@"
    EOS
  end

  test do
    assert_match "Lana #{version} (LABC v1,", shell_output("#{bin}/lana version")
    system bin/"lana", "new", "hello-lana"
    Dir.chdir("hello-lana") do
      system bin/"lana", "build"
      system bin/"lana", "run"
    end
  end
end
