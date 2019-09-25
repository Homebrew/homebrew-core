class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno.git",
    :tag      => "v0.19.0",
    :revision => "3892cf59018acd71dd4bc1099d747bd683cd4118"

  bottle do
    cellar :any_skip_relocation
    sha256 "da632790017b854b83979e669540a9838f2e6fc90a774f8949cdad7ac1c58252" => :mojave
    sha256 "29e0d32f4cdd1eccedbf99c1d34e32a122bbf52bd1fe26117b36828914e5446d" => :high_sierra
    sha256 "f4342bd032162474583c14caf29f0cb9fd72bc62059604397b3fb362c999ce38" => :sierra
  end

  depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1100
  depends_on "ninja" => :build
  depends_on "rust" => :build

  depends_on :xcode => ["10.0", :build] # required by v8 7.9+

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

    # workaround for xcode-select --print-path pointing to CLT
    inreplace "core/libdeno/build/config/mac/mac_sdk.gni",
              "\"--print_bin_path\",",
              "\"--print_bin_path\", \"--developer_dir\", \"#{MacOS::Xcode.bundle_path}\""

    # env args for building a release build with our clang, ninja and gn
    ENV["DENO_NO_BINARY_DOWNLOAD"] = "1"
    ENV["DENO_GN_PATH"] = buildpath/"gn/out/gn"
    args = %W[
      clang_use_chrome_plugins=false
      mac_deployment_target="#{MacOS.version}"
      treat_warnings_as_errors=false
    ]
    if DevelopmentTools.clang_build_version < 1100
      # build with llvm and link against system libc++ (no runtime dep)
      args << "clang_base_path=\"#{Formula["llvm"].prefix}\""
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    else # build with system clang
      args << "clang_base_path=\"/usr/\""
    end
    ENV["DENO_BUILD_ARGS"] = args.join(" ")

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
