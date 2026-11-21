class Lightpanda < Formula
  desc "Headless browser designed for web automation"
  homepage "https://github.com/lightpanda-io/browser"
  url "https://github.com/lightpanda-io/browser/archive/refs/tags/1.0.4.tar.gz"
  sha256 "1a6012705a755b76eade6836f0af628256384685af5adbb124dd2af21508077d"
  license "AGPL-3.0-only"
  head "https://github.com/lightpanda-io/browser.git", branch: "main"

  depends_on "glib" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zig" => :build

  on_linux do
    depends_on "libffi" => :build
    depends_on "pcre2" => :build

    on_arm do
      depends_on "lld" => :build
      depends_on "llvm" => :build
    end
  end

  deny_network_access!

  def fetch
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    system "zig", "build", "--fetch=all"
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "src/rust/Cargo.toml"

    v8_build = Dir[buildpath/"zig-pkg/v8-*/build.zig"].first
    if OS.mac?
      # The standalone V8 build vendors its own copy of depot_tools.
      system "zig", "build", "--build-file", v8_build, "--fetch=all"
      # Keep gsutil's multiprocessing sockets inside Homebrew's private TMPDIR.
      Dir[buildpath/"zig-pkg/**/download_from_google_storage.py"].each do |downloader|
        inreplace downloader,
                  'env.update((x, "/tmp") for x in _TEMPDIR_ENV_VARS)',
                  'env.update((x, os.environ.get("TMPDIR", "/tmp")) for x in _TEMPDIR_ENV_VARS)'
      end

      # V8's hooks use a separately checked-out depot_tools; patch it before running them.
      inreplace v8_build, '        "sync",', '        "sync", "--nohooks",'
      inreplace v8_build, "create_marker.step.dependOn(&clang_update.step);",
                          "create_marker.step.dependOn(&gclient_sync.step);"
      inreplace v8_build, "        return gpa.dupe(u8, args.items);", <<~'ZIG'
        if (tag == .macos) try args.appendSlice(gpa, "use_lld=false\\n");

        return gpa.dupe(u8, args.items);
      ZIG
    elsif OS.linux? && Hardware::CPU.arm?
      # Upstream assumes Debian's LLVM installation on Linux ARM64.
      llvm = Formula["llvm"]
      inreplace v8_build, "/usr/lib/llvm-23", llvm.opt_prefix.to_s
      inreplace v8_build, 'clang_version=\"23\"', "clang_version=\\\"#{llvm.version.major}\\\""
      inreplace v8_build, "        return gpa.dupe(u8, args.items);", <<~ZIG
        try args.appendSlice(gpa, "lld_path=\\"#{formula_opt_bin("lld")}\\"\\n");

        return gpa.dupe(u8, args.items);
      ZIG
    end
    system "zig", "build", "--build-file", v8_build, "prepare-v8", "-Dcache_root=#{buildpath}/.lp-cache"

    if OS.mac?
      v8_dir = Pathname(Dir[buildpath/".lp-cache/v8-*"].first)
      depot_tools = Pathname(Dir[buildpath/".lp-cache/depot_tools-*"].first)
      inreplace v8_dir/"third_party/depot_tools/download_from_google_storage.py",
                'env.update((x, "/tmp") for x in _TEMPDIR_ENV_VARS)',
                'env.update((x, os.environ.get("TMPDIR", "/tmp")) for x in _TEMPDIR_ENV_VARS)'
      ENV.prepend_path "PATH", depot_tools
      cd v8_dir do
        system depot_tools/"gclient", "runhooks"
        system depot_tools/"python-bin/python3", "tools/clang/scripts/update.py"
      end
      revision = v8_dir/"third_party/llvm-build/Release+Asserts/cr_build_revision"
      odie "V8 Clang bootstrap did not create #{revision}" unless revision.file?
    end
  end

  def install
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    system "zig", "build", *std_zig_args, "-Dversion=#{version}"
  end

  service do
    run [opt_bin/"lightpanda", "serve", "--host", "127.0.0.1", "--port", "9222"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lightpanda version")
    html = shell_output("#{bin}/lightpanda fetch --dump html 'data:text/html,%3Ch1%3EHomebrew%3C%2Fh1%3E'")
    assert_match "Homebrew", html
  end
end
