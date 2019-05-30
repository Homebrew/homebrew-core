class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno.git",
    :tag      => "v0.7.0",
    :revision => "5265bd7cb1f86af99b01d73c537d52a50df95fe2"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e077eed0c3a9c6d8be45e8f6399f353b3bbb575e338d727fb5ca45a9e36adea" => :mojave
    sha256 "14e605357405b92b5a54d53a826373395607e8d80f6d1662760828ecd7000fbb" => :high_sierra
    sha256 "e5c62a72c93162f6f4c6e04965ad2d991651e6cca28b1ed481d3b8d22ef1023b" => :sierra
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
