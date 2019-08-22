class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno.git",
    :tag      => "v0.16.0",
    :revision => "0809b06a3938868f364f1343b0de4d5d9686495d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea41466b5e1472ad47eb3b6feb91453ff923b7a0d79b55dc93412514c677fbaa" => :mojave
    sha256 "2ce2e8d758fb93715a904dc9170f56b98949b7d03cc3c273925499979922c576" => :high_sierra
    sha256 "73aed6aab2ddc5b6f8f50a81ad312efe677dd52731ab1820382c53ddf7b6f9da" => :sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "rust" => :build

  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "81ee1967d3fcbc829bac1c005c3da59739c88df9"
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
      mac_deployment_target="#{MacOS.version}"
    ].join(" ")
    ENV["DENO_NINJA_PATH"] = Formula["ninja"].bin/"ninja"
    ENV["DENO_GN_PATH"] = buildpath/"gn/out/gn"

    system "python", "tools/setup.py", "--no-binary-download"
    system "python", "tools/build.py", "--release"

    bin.install "target/release/deno"

    # Install bash and zsh completion
    output = Utils.popen_read("#{bin}/deno completions bash")
    (bash_completion/"deno").write output
    output = Utils.popen_read("#{bin}/deno completions zsh")
    (zsh_completion/"_deno").write output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    hello = shell_output("#{bin}/deno run hello.ts")
    assert_includes hello, "hello deno"
  end
end
