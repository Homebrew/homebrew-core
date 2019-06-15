class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno.git",
    :tag      => "v0.9.0",
    :revision => "7b06aa37342c021f9f1fac99125847d134e67001"

  bottle do
    cellar :any_skip_relocation
    sha256 "e005e62a8ae6a554b5f950d0d6dac23e56bcad47600754d405b6ce37ced58989" => :mojave
    sha256 "5984b9e6e7b121cb4132a4ef4076a3beec013785ab849a5318a74b181a8a0cad" => :high_sierra
    sha256 "5cb0c1a8bf1d1fb3961450e1a86b058ac9c4c9ae78fbc4621effe29fd25c7699" => :sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "rust" => :build

  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "64b846c96daeb3eaf08e26d8a84d8451c6cb712b"
  end

  def install
    # Build gn from source (used as a build tool here)
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end

    # env args for building a release build with our clang, ninja and gn
    ENV["DENO_BUILD_MODE"] = "release"
    ENV["DENO_BUILD_ARGS"] = %W[
      clang_base_path="#{Formula["llvm"].prefix}"
      clang_use_chrome_plugins=false
    ].join(" ")
    ENV["DENO_NINJA_PATH"] = Formula["ninja"].bin/"ninja"
    ENV["DENO_GN_PATH"] = buildpath/"gn/out/gn"

    system "python", "tools/setup.py", "--no-binary-download"
    system "python", "tools/build.py", "--release"

    bin.install "target/release/deno"
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    hello = shell_output("#{bin}/deno run hello.ts")
    assert_includes hello, "hello deno"
  end
end
