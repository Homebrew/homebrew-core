class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.49.1",
      revision: "c09be039cb46fd05623d83e365b4eaf164171dab"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad1cb21dc7ba6f668537a246f59d896ef16a23c26d44401874c8e13d126749fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f6298e2a186841fc3ed93e5600d465daaf29b551aa12bc2ea8f4e7209c7fec6"
    sha256 cellar: :any_skip_relocation, monterey:       "3b2d5044ae4510af39e06bcbefc69a62ceea9426947a68694a6233893e9de12a"
    sha256 cellar: :any_skip_relocation, big_sur:        "da4072a6b93a6ce57e0c424b63d05b5547d4c46411fd2fccff7b755f60e08e69"
    sha256 cellar: :any_skip_relocation, catalina:       "55a008396f089a9989e8251166d756752dd32679cd6d7165da71c4774a18dc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75364a71502378ec8e844f11200f38614c2aa332ba7ce91063283ef2b8cc162e"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
