class AsciiChat < Formula
  desc "Real-time terminal video chat with ASCII art conversion"
  homepage "https://github.com/zfogg/ascii-chat"
  url "https://github.com/zfogg/ascii-chat/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "d670eb706c98956c9b885ab7ca391883d43a57212fea54a76b004be9dea57d9e"
  license "MIT"
  head "https://github.com/zfogg/ascii-chat.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "git" => :build
  depends_on "lld" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "ffmpeg"
  depends_on "libsodium"
  depends_on "llvm"
  depends_on "mimalloc"
  depends_on "miniupnpc"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "portaudio"
  depends_on "sqlite"
  depends_on "zstd"

  resource "bearssl" do
    url "https://www.bearssl.org/bearssl-0.6.tar.gz"
    sha256 "6705bba1714961b41a728dfc5debbe348d2966c117649392f8c8139efc83ff14"
  end

  resource "libsodium-bcrypt-pbkdf" do
    url "https://github.com/zfogg/libsodium-bcrypt-pbkdf/archive/650031b7e82bad719b8e1c98f51522f68e4a10e0.tar.gz"
    sha256 "80e54cd9d509de178c2029a1e30b84b4cf07101760f9b38088fd4fcaa56431f0"
  end

  resource "mdns" do
    url "https://github.com/mjansson/mdns/archive/a569c4759bd47e0f2a7bfc4d4c19620445782806.tar.gz"
    sha256 "8a82a92bb025f3abcfb18e666c388aabc4730da3ba116b412d5c0ead466d33be"
  end

  resource "sokol" do
    url "https://github.com/floooh/sokol/archive/f38e0b520f99a501b71172c3a3181c9ab6ebdd79.tar.gz"
    sha256 "baba806c97ba23a414bf09c29830fe4af16561174e19baa0cf8027cccb33a01d"
  end

  resource "tomlc17" do
    url "https://github.com/cktan/tomlc17/archive/7f3bd33e7356787f665fc7c06ff81d38adb8158c.tar.gz"
    sha256 "e1003e4a640e503b3d0c486b3508cede9c9c177bae38961005211bd78c4c2042"
  end

  def install
    if build.head?
      # HEAD build: use git submodules
      system "git", "submodule", "update", "--init", "--recursive"
    else
      # Stable build: stage vendored dependencies from resources
      (buildpath/"deps/bearssl").install resource("bearssl")
      (buildpath/"deps/libsodium-bcrypt-pbkdf").install resource("libsodium-bcrypt-pbkdf")
      (buildpath/"deps/mdns").install resource("mdns")
      (buildpath/"deps/sokol").install resource("sokol")
      (buildpath/"deps/tomlc17").install resource("tomlc17")

      # Create git repo for version detection (tarball has no .git)
      system "git", "init"
      system "git", "config", "user.email", "brew@localhost"
      system "git", "config", "user.name", "Homebrew"
      system "git", "add", "-A"
      system "git", "commit", "-m", "v#{version}"
      system "git", "tag", "v#{version}"
    end

    # Use Homebrew LLVM for consistent ABI
    llvm = Formula["llvm"]
    ENV["CC"] = llvm.opt_bin/"clang"
    ENV["CXX"] = llvm.opt_bin/"clang++"
    ENV["OBJC"] = llvm.opt_bin/"clang"
    ENV["OBJCXX"] = llvm.opt_bin/"clang++"

    # Set up linker flags for Homebrew dependencies
    ENV["LDFLAGS"] = "-L#{HOMEBREW_PREFIX}/lib -L#{llvm.opt_lib}/unwind -lunwind"
    ENV["CPPFLAGS"] = "-I#{HOMEBREW_PREFIX}/include"
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/lib/pkgconfig:#{HOMEBREW_PREFIX}/share/pkgconfig"

    # Download pre-built defer tool
    defer_tool_dir = buildpath/".deps-cache/defer-tool"
    defer_tool_dir.mkpath
    defer_tool_path = defer_tool_dir/"ascii-instr-defer"

    defer_url = if OS.mac?
      "https://github.com/zfogg/ascii-chat/releases/download/build-tools/ascii-instr-defer.macOS.universal"
    elsif Hardware::CPU.arm?
      "https://github.com/zfogg/ascii-chat/releases/download/build-tools/ascii-instr-defer.Linux.arm64"
    else
      "https://github.com/zfogg/ascii-chat/releases/download/build-tools/ascii-instr-defer.Linux.amd64"
    end
    system "curl", "-fsSL", "-o", defer_tool_path, defer_url
    defer_tool_path.chmod 0755

    # Get macOS SDK path
    sdk_path = if OS.mac?
      Utils.safe_popen_read("xcrun", "--show-sdk-path").chomp
    else
      ""
    end

    cmake_args = std_cmake_args + %W[
      -G Ninja
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX};#{Formula["mimalloc"].opt_prefix}
      -DASCIICHAT_SHARED_DEPS=ON
      -DASCIICHAT_DEFER_TOOL=#{defer_tool_path}
      -DASCIICHAT_ENABLE_ANALYZERS=OFF
      -DASCIICHAT_LLVM_CONFIG_EXECUTABLE=#{llvm.opt_bin}/llvm-config
      -DASCIICHAT_CLANG_EXECUTABLE=#{llvm.opt_bin}/clang
      -DASCIICHAT_CLANG_PLUS_PLUS_EXECUTABLE=#{llvm.opt_bin}/clang++
      -DASCIICHAT_LLVM_AR_EXECUTABLE=#{llvm.opt_bin}/llvm-ar
      -DASCIICHAT_LLVM_RANLIB_EXECUTABLE=#{llvm.opt_bin}/llvm-ranlib
      -DASCIICHAT_LLVM_NM_EXECUTABLE=#{llvm.opt_bin}/llvm-nm
      -DASCIICHAT_LLVM_READELF_EXECUTABLE=#{llvm.opt_bin}/llvm-readelf
      -DASCIICHAT_LLVM_OBJDUMP_EXECUTABLE=#{llvm.opt_bin}/llvm-objdump
      -DASCIICHAT_LLVM_STRIP_EXECUTABLE=#{llvm.opt_bin}/llvm-strip
      -DASCIICHAT_LLD_EXECUTABLE=#{Formula["lld"].opt_bin}/ld.lld
    ]

    if OS.mac?
      cmake_args += %W[
        -DCMAKE_OSX_SYSROOT=#{sdk_path}
        -DCMAKE_OBJC_COMPILER=#{llvm.opt_bin}/clang
        -DCMAKE_OBJCXX_COMPILER=#{llvm.opt_bin}/clang++
        -DCMAKE_EXE_LINKER_FLAGS=-L#{HOMEBREW_PREFIX}/lib\ -L#{llvm.opt_lib}/unwind\ -lunwind
        -DCMAKE_SHARED_LINKER_FLAGS=-L#{HOMEBREW_PREFIX}/lib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *cmake_args

    # Build shared library
    system "cmake", "--build", "build", "--target", "shared-lib"
    system "cmake", "--build", "build", "--target", "static-lib"

    # Install library components
    system "cmake", "--install", "build", "--component", "Unspecified"
    system "cmake", "--install", "build", "--component", "Development"

    # Build and install the binary
    system "cmake", "--build", "build", "--target", "ascii-chat"
    system "cmake", "--build", "build", "--target", "man1"

    bin.install "build/bin/ascii-chat"
    man1.install "build/share/man/man1/ascii-chat.1"
    bash_completion.install "share/bash-completion/completions/ascii-chat"
    zsh_completion.install "share/zsh/site-functions/_ascii-chat"
    fish_completion.install "share/fish/vendor_completions.d/ascii-chat.fish"
  end

  service do
    run [opt_bin/"ascii-chat", "server"]
    keep_alive crashed: true
    working_dir var
    log_path var/"log/ascii-chat.log"
    error_log_path var/"log/ascii-chat.log"
  end

  test do
    assert_match "ascii-chat", shell_output("#{bin}/ascii-chat --help 2>&1")
    assert_match version.to_s, shell_output("#{bin}/ascii-chat --version 2>&1")
  end
end
