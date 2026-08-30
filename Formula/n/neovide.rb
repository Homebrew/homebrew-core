class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://neovide.dev/"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.16.2.tar.gz"
  sha256 "a2016cceab3cba50b6a8b2f6787ae9017a85923575e89a83ebb9d428e8f80ca9"
  license "MIT"
  revision 2
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f70aefe0ac4f6aea19620681dbdcbadd00fdc2bad3ebd184c801628cefd31392"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb128713d1da6d589f2b9497e90925f499870f3940b94c6beefe1bd497d7653f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0d31361975e2f50ef1d17080167f9009da58b5ccba7e3df3c782145552c8aeb"
    sha256 cellar: :any,                 arm64_linux:       "61e2d278c9d005c525d4f603e0ac234ed0c09981fcbfa05f4756e6dbb21b0884"
    sha256 cellar: :any,                 x86_64_linux:      "8acbd21a7bb32aa6f7f4c66178986b267d7afdf861e7145636ab06f1ac1fb6a4"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  on_macos do
    # work around https://github.com/rust-skia/rust-skia/issues/1331
    depends_on "llvm@22" => :build if DevelopmentTools.clang_build_version >= 2100
  end

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "desktop-file-utils"
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@79"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    # `libxcursor` is loaded when using X11 (DISPLAY) instead of Wayland (WAYLAND_DISPLAY).
    # Once https://github.com/rust-windowing/winit/commit/aee95114db9c90eef6f4d895790552791cf41ab9
    # is in a `winit` release, check `lsof -p <neovide-pid>` to see if dependency can be removed
    depends_on "libxcursor"
    depends_on "libxkbcommon" # dynamically loaded by xkbcommon-dl
    depends_on "mesa" # dynamically loaded by glutin
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    cause "Skia build uses clang target option"
  end

  def install
    ENV["FORCE_SKIA_BUILD"] = "1" # avoid pre-built `skia`

    # FIXME: On macOS, `skia-bindings` crate only allows building `skia` with bundled libraries
    if OS.linux?
      ENV["SKIA_USE_SYSTEM_LIBRARIES"] = "1"
      ENV["CLANG_PATH"] = which(ENV.cc) # force bindgen to use superenv clang to find brew libraries

      # GN doesn't use CFLAGS so pass extra paths using superenv
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", formula_opt_include("freetype")/"freetype2"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", formula_opt_include("harfbuzz")/"harfbuzz"
    elsif DevelopmentTools.clang_build_version >= 2100
      # Work around https://github.com/rust-skia/rust-skia/issues/1331
      ENV["CLANG_PATH"] = formula_opt_bin("llvm@22")/"clang"
    end

    system "cargo", "install", *std_cargo_args

    if OS.linux?
      (share/"applications").install "assets/neovide.desktop"
      (share/"icons/hicolor/scalable/apps").install "assets/neovide.svg"
      %w[16x16 32x32 48x48 256x256].each do |size|
        (share/"icons/hicolor/#{size}/apps").install "assets/neovide-#{size}.png" => "neovide.png"
      end
    end

    return unless OS.mac?

    # Use upstream's app template, as their release builds do
    prefix.install "extra/osx/Neovide.app"
    (prefix/"Neovide.app/Contents/MacOS").install bin/"neovide"
    bin.write_exec_script prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  post_install_steps do
    on_linux do
      update_desktop_database
    end
  end

  def nvim_ui_count(socket)
    Utils.safe_popen_read(
      "nvim", "--headless",
              "--server", socket,
              "--remote-expr", 'luaeval("vim.tbl_count(vim.api.nvim_list_uis())")'
    ).chomp.to_i
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neovide --version")
    return if OS.mac? # unable to start neovide within macOS sandbox

    socket = testpath/"nvim.sock"
    nvim_cmd = ["nvim", "--headless", "-i", "NONE", "-u", "NONE", "--listen", socket]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 1 until socket.exist? && socket.socket?

    IO.pipe do |read_io, write_io|
      xvfb = formula_opt_bin("xorg-server")/"Xvfb"
      xvfb_pid = spawn(xvfb, "-displayfd", write_io.fileno.to_s, write_io => write_io)
      write_io.close
      ENV["DISPLAY"] = ":#{read_io.read.strip}"

      neovide_cmd = [bin/"neovide", "--no-fork", "--server=#{socket}"]
      ohai neovide_cmd.join(" ")
      neovide_pid = spawn(*neovide_cmd)

      sleep 1 until nvim_ui_count(socket).positive?
      system "nvim", "--server", socket, "--remote-send", ":q<CR>"

      Process.wait nvim_pid
      Process.wait neovide_pid
    ensure
      if xvfb_pid
        Process.kill "TERM", xvfb_pid
        Process.wait xvfb_pid
      end
    end
  end
end
