class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno.git",
    :tag      => "v0.6.0",
    :revision => "22feb74ba12215597416b5531f8a557302283e79"

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
    # Build gn from source, move it to the expected location and add it to the PATH
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    (buildpath/"third_party/v8/buildtools/mac").install buildpath/"gn/out/gn"
    ENV.prepend_path "PATH", buildpath/"third_party/v8/buildtools/mac"

    # GN args for building a release build with homebrew clang / llvm
    gn_args = {
      :clang_base_path   => "\"#{Formula["llvm"].prefix}\"",
      :is_debug          => false,
      :is_official_build => true,
      :symbol_level      => 0,
    }
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")
    ENV["DENO_BUILD_MODE"] = "release"

    # Build with the homebrew provided gn and ninja
    system "gn", "gen", "--args=#{gn_args_string}", "target/release"
    system "ninja", "-j", ENV.make_jobs, "-C", "target/release", "-v", "deno"

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
