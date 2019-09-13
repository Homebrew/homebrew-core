class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno.git",
    :tag      => "v0.18.0",
    :revision => "7e3296dad92cee2e8b77baedfbeca38aa297928e"

  bottle do
    cellar :any
    sha256 "70bcca9e5ab6f52eb1efa03b8428c0c29cc178a5fb5b83b32457549581886d1f" => :mojave
    sha256 "030fb930565692470fd7e6022a3d48e9f3ad79c7c7b80fd46c79e905d0e72465" => :high_sierra
    sha256 "a63d4e45131199cd9f851a5b36f441346d175d93b2d6ed02ccf8c713081da5fc" => :sierra
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "llvm"

  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "972ed755f8e6d31cae9ba15fcd08136ae1a7886f"
  end

  def install
    # Build gn from source (used as a build tool here)
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end

    # env args for building a release build with our clang, ninja and gn
    ENV["DENO_NO_BINARY_DOWNLOAD"] = "1"
    ENV["FORCE_MAC_SDK_MIN"] = "10.12"
    # remove treat_warnings_as_errors with llvm@9
    ENV["DENO_BUILD_ARGS"] = %W[
      clang_base_path="#{Formula["llvm"].prefix}"
      clang_use_chrome_plugins=false
      mac_deployment_target="#{MacOS.version}"
      treat_warnings_as_errors=false
    ].join(" ")
    ENV["DENO_NINJA_PATH"] = Formula["ninja"].bin/"ninja"
    ENV["DENO_GN_PATH"] = buildpath/"gn/out/gn"

    cd "cli" do
      system "cargo", "install", "-vv", "--root", prefix, "--path", "."
    end

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
