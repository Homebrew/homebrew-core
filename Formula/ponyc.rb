class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.36.0",
      revision: "642d92cbbb0ed5fdec8806a47bafbb447f5a1511"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5ee5c7de9411cd4ef0a89ec20ecf4b65b24f909140ab471b1ed363848eb2d21" => :catalina
    sha256 "850f9ce9041cd9d730cd0f7436640164513fea9e87d1700b9a1407a78ddc780f" => :mojave
    sha256 "be3c504153f0c4b1402263820f51578c720c6a03d7b4b06ac2e0f1ccb82f13b7" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

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
