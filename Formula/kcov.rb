class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/38.tar.gz"
  sha256 "b37af60d81a9b1e3b140f9473bdcb7975af12040feb24cc666f9bb2bb0be68b4"
  license "GPL-2.0"
  revision 1
  head "https://github.com/SimonKagstrom/kcov.git"

  # add livecheck to avoid release tags like `pre-v40`
  # which is tagged as latest release as well
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6e098f67e1795b2e1e9a8075c05a16cbb5b113a6158b8d071a0d5f366e2e96e0" => :big_sur
    sha256 "610b866cd332293fd75d9491c951ce33ba5b2ffdc9957b5ed0cf34c182bd6827" => :arm64_big_sur
    sha256 "84e08342871b62bb65fd89ba6612ea8826db9be3a93f84d5ba25bdf05a8ef01b" => :catalina
    sha256 "583b5fe1351a6a3148a4e030701143a99e08d71f184f85e97c69864543f4de54" => :mojave
    sha256 "2dfacc1726aba5b15a18e0b845d3bb84cf93d5e320ebbf47e6c66960a80e231c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on :macos # Due to Python 2

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
