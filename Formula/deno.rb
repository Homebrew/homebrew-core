class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno.git",
    :tag      => "v0.17.0",
    :revision => "82588ec09c199683cff88097e1b90649497239c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "40cf36716f92b92f76266e848ea0eab0cc2eb650f4d3c5b9ee6f67d534f7397b" => :mojave
    sha256 "96e525af076b48951a045969c0a010edc59d9a07914b5bd6167cafabc0265d1c" => :high_sierra
    sha256 "53c554f9e6296ead230ad0277634f036a6bfea70071c98478f8d254332fb3a22" => :sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
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
