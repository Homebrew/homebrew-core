class Bun < Formula
  desc "Fast all-in-one JavaScript runtime"
  homepage "https://bun.sh"
  license "MIT"

  stable do
    # pull from git tag to get submodules
    url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v0.1.6",
      revision: "fcce3ff5ac821de270e5d0094d665ec079ef205e"

    # Requires unreleased zig version (0.10.0)
    # Commit from latest fork: https://github.com/Jarred-Sumner/zig
    resource "zig" do
      url "https://github.com/ziglang/zig/archive/b79884eaf003ad32e800213c20da5c6b8935af34.tar.gz"
      sha256 "f69d7525304720372520482bd54fbf62621c15b4d201465567939b15d0ba1ae5"
    end
  end

  livecheck do
    url :stable
    regex(/bun-v?(\d+(?:\.\d+)+)/i)
  end

  head do
    url "https://github.com/oven-sh/bun.git", branch: "main"

    resource "zig" do
      url "https://github.com/Jarred-Sumner/zig.git", branch: "master"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "esbuild" => :build
  depends_on "gnu-sed" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "llvm@13" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    ENV["ZIG"] = buildpath/"bin/zig"
    resource("zig").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: buildpath), "-DZIG_STATIC_LLVM=ON"
      system "make", "install"
    end

    ENV.delete("HOMEBREW_SDKROOT")
    ENV["CPUS"] = ENV.make_jobs.to_s
    ENV["LIBICONV_PATH"] = "#{MacOS.sdk_path}/usr/lib/libiconv.tbd" if OS.mac?
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["LLVM_PREFIX"] = Formula["llvm@13"].opt_prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@13"].opt_lib
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
    ENV.deparallelize

    system "make", "vendor", "identifier-cache", "build-obj", "jsc", "bun-link-lld-release-no-lto"
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86"
    bin.install "packages/bun-#{OS.kernel_name.downcase}-#{cpu}/bun"

    # Install shell completions
    bash_completion.install "completions/bun.bash" => "bun"
    zsh_completion.install "completions/bun.zsh" => "_bun"
    fish_completion.install "completions/bun.fish"
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "bun");
    EOS
    assert_match "hello bun", shell_output("#{bin}/bun run hello.ts")
  end
end
