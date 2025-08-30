class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/luoliwoshang/llgo"
  url "https://github.com/luoliwoshang/llgo/archive/refs/tags/v0.12.12.tar.gz"
  sha256 "20c1c968c955dcc3157445c788804ecbd85dbcac248c99c8dfd27bcc3b09e61d"
  license "Apache-2.0"
  head "https://github.com/luoliwoshang/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "0947ad7513fea18ae89e066e0bbb4ed3c6dc0299ead7d69a4cb57b6f3941d36f"
    sha256 cellar: :any, arm64_sonoma:  "7de761a6c845ba0a46d27164595fdf5c779cab4fea67cdcc927b696eab7b97d9"
    sha256 cellar: :any, arm64_ventura: "cacaa00dc85e867d7c346af23319ecc37dd1518acadacb1329072f2764beb52a"
    sha256 cellar: :any, sonoma:        "c1d46f74280d51ae465daa27d47c9e06e4da328d52f74a4b871551d4ccfffab5"
    sha256 cellar: :any, ventura:       "a6022098d5a0ef86f343ce6aca0c983caa53b8c836ab620212da8b459359631b"
    sha256               x86_64_linux:  "2486bc3ddd7c27fe03c9ae10df73553c09b9f21b3d4dc94b55f99da632dbbf5f"
  end

  depends_on "bdw-gc"
  depends_on "go@1.24"
  depends_on "libffi"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "pkgconf"
  uses_from_macos "zlib"

  resource "espressif-llvm" do
    on_macos do
      on_arm do
        url "https://github.com/goplus/espressif-llvm-project-prebuilt/releases/download/19.1.2_20250820/clang-esp-19.1.2_20250820-aarch64-apple-darwin.tar.xz"
        sha256 "447a8c4ebcb4d69b9a2ad24974fa48cb57c46b1eb21202bd62169281bbb37f56"
      end
      on_intel do
        url "https://github.com/goplus/espressif-llvm-project-prebuilt/releases/download/19.1.2_20250820/clang-esp-19.1.2_20250820-x86_64-apple-darwin.tar.xz"
        sha256 "05fb85702c3ae7623d950dbd5ca7305b7c22026568981bce1c6a4ff566b42b2d"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/goplus/espressif-llvm-project-prebuilt/releases/download/19.1.2_20250820/clang-esp-19.1.2_20250820-aarch64-linux-gnu.tar.xz"
        sha256 "a7153ee9a0541151faf7b6fb9eddb0974716a84da37cb0338b027b585443984a"
      end
      on_intel do
        url "https://github.com/goplus/espressif-llvm-project-prebuilt/releases/download/19.1.2_20250820/clang-esp-19.1.2_20250820-x86_64-linux-gnu.tar.xz"
        sha256 "f830174e86860c68f6a91e92846be194ca674e205e02b1b739ed29cc952af4f6"
      end
    end
  end

  def find_dep(name)
    deps.find { |f| f.name.match?(/^#{name}(@\d+(\.\d+)*)?$/) }
        .to_formula
  end

  def install
    ohai "Platform: #{OS.mac? ? "macOS" : "Linux"} #{Hardware::CPU.arch}"
    ohai "Installing ESP32 toolchain..."
    resource("espressif-llvm").stage do
      ohai "llvm downloaded to: #{Dir.pwd}"
      ohai "Downloaded contents: #{Dir.glob("*").join(", ")}"

      (libexec/"crosscompile/clang").mkpath

      cp_r Dir["*"], libexec/"crosscompile/clang"

      ohai "Toolchain installed to: #{libexec}/crosscompile/clang"
    end

    local_llvm_config = libexec/"crosscompile/clang/bin/llvm-config"

    ldflags = %W[
      -s -w
      -X github.com/goplus/llgo/internal/env.buildVersion=v#{version}
      -X github.com/goplus/llgo/internal/env.buildTime=#{time.iso8601}
      -X github.com/goplus/llgo/xtool/env/llvm.ldLLVMConfigBin=#{local_llvm_config}
    ]
    tags = nil
    if OS.linux?
      local_llvm_include = libexec/"crosscompile/clang/include"
      local_llvm_lib = libexec/"crosscompile/clang/lib"

      ENV.prepend "CGO_CPPFLAGS",
        "-I#{local_llvm_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{local_llvm_lib} -lLLVM"
      tags = "byollvm"

      ohai "Linux CGO setup - Include: #{local_llvm_include}, Lib: #{local_llvm_lib}"
    end

    ohai "Building LLGO..."
    system "go", "build", *std_go_args(ldflags:, tags:), "-o", libexec/"bin/", "./cmd/llgo"

    libexec.install "LICENSE", "README.md", "go.mod", "go.sum", "runtime"

    path_deps = %w[go pkgconf].map { |name| find_dep(name).opt_bin }
    path_deps << (libexec/"crosscompile/clang/bin")
    script_env = { PATH: "#{path_deps.join(":")}:$PATH" }

    if OS.linux?
      local_llvm_include = libexec/"crosscompile/clang/include"
      local_llvm_lib = libexec/"crosscompile/clang/lib"
      script_env[:CFLAGS] = "-I#{local_llvm_include} $CFLAGS"
      script_env[:LDFLAGS] = "-L#{local_llvm_lib} -rpath #{local_llvm_lib} $LDFLAGS"
    end

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd, script_env
    end
  end

  test do
    go = find_dep("go")
    goos = shell_output("#{go.opt_bin}/go env GOOS").chomp
    goarch = shell_output("#{go.opt_bin}/go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp

    # Add bdw-gc library path to LD_LIBRARY_PATH, this is a workaround for the libgc.so not found issue
    # Will be fixed in the next release
    bdwgc = find_dep("bdw-gc")
    ENV.prepend_path "LD_LIBRARY_PATH", bdwgc.opt_lib

    (testpath/"hello.go").write <<~GO
      package main

      import (
          "fmt"

          "github.com/goplus/lib/c"
          "github.com/goplus/lib/cpp/std"
      )

      func Foo() string {
        return "Hello LLGo by Foo"
      }

      func main() {
        fmt.Println("Hello LLGo by fmt.Println")
        c.Printf(c.Str("Hello LLGo by c.Printf\\n"))
        c.Printf(std.Str("Hello LLGo by cpp/std.Str\\n").CStr())
      }
    GO
    (testpath/"hello_test.go").write <<~GO
      package main

      import "testing"

      func Test_Foo(t *testing.T) {
        got := Foo()
        want := "Hello LLGo by Foo"
        if got != want {
          t.Errorf("foo() = %q, want %q", got, want)
        }
      }
    GO
    (testpath/"go.mod").write <<~GOMOD
      module hello
    GOMOD
    system go.opt_bin/"go", "get", "github.com/goplus/lib"
    # Test llgo run
    assert_equal "Hello LLGo by fmt.Println\n" \
                 "Hello LLGo by c.Printf\n" \
                 "Hello LLGo by cpp/std.Str\n",
                 shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGo by fmt.Println\n" \
                 "Hello LLGo by c.Printf\n" \
                 "Hello LLGo by cpp/std.Str\n",
                 shell_output("./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test .")
  end
end
