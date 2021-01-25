class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/38.tar.gz"
  sha256 "b37af60d81a9b1e3b140f9473bdcb7975af12040feb24cc666f9bb2bb0be68b4"
  license "GPL-2.0"
  revision 1
  head "https://github.com/SimonKagstrom/kcov.git"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e8181653c02129bd63fd438d3e5965cd25d5408ebe7c6699da2ab86b9a9f4340" => :big_sur
    sha256 "32aab6003ab8ca0cf45e55415ae5b78e6fc59f5e02fa1d84397df1be17261230" => :arm64_big_sur
    sha256 "becb863fd482145cd67dab0b25df128b5deba598fa89a217cd6ff63ba79edbc5" => :catalina
    sha256 "dd72670ef6f9abd9b44bf70b8fcb64faffe1ba4edfd4704c70de395d3594dc89" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "cmake", "-DSPECIFY_RPATH=ON", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
