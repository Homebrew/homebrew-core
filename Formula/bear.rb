class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.8.tar.gz"
  sha256 "1c0ea23e5ef05eb8113cffd8da345dc82e91d0318488606cd7d5ca974842b81b"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "7ecb93558881ac6d2c1d7e757ba413cf2484d567de7681b274fa6f7fc85511aa" => :high_sierra
    sha256 "78d598f509842388e23d2dd77c319847c6038d80032114170cc6531175bb5ba4" => :sierra
    sha256 "74741c80702739a0e0a1da5f674f022a5ebb26e497cbf11cde378bdadb3e7e73" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
