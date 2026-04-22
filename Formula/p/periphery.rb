class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.7.2.tar.gz"
  sha256 "1825891157144c2d61bedeeb6f4058c1ca071156a485fe07368d14aa98091011"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25a1cdb3b1adcaf3a5c6ede8e55f44ad379acabaacf44f3a7b11066f521e4fa7"
    sha256 cellar: :any,                 arm64_sequoia: "9ce7f186010d9e3f768acb1c2588fe1c07af759bc498724c20807c788d2786c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4841673495dcb3f05ef66981dd4c23fa334b3fec895dc7bde8fa0104984d5132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27162bc80b8728c8c8be65b8925b489a0e68dd9b4228b0371e3b2e843bd649fc"
  end

  depends_on xcode: ["16.4", :build]

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".build/release/periphery"

    if OS.mac?
      toolchain_lib = Pathname(
        Utils.safe_popen_read("/usr/bin/xcode-select", "-p").strip,
      )/"Toolchains/XcodeDefault.xctoolchain/usr/lib"
      indexstore = toolchain_lib/"libIndexStore.dylib"
      odie "Missing libIndexStore in #{toolchain_lib}" unless indexstore.exist?
      lib.mkpath
      cp indexstore, lib/"libIndexStore.dylib"

      # The binary inherits an absolute Xcode toolchain rpath from the build environment.
      # Replace it with a loader-relative path so the bundled lib is used instead.
      toolchain_rpaths = []
      inside_rpath_command = false
      Utils.safe_popen_read("/usr/bin/otool", "-l", bin/"periphery").each_line do |line|
        if line.include?("cmd LC_RPATH")
          inside_rpath_command = true
          next
        end

        next unless inside_rpath_command
        next unless line.lstrip.start_with?("path ")

        path = line.split[1]
        toolchain_rpaths << path if path == toolchain_lib.to_s || path.start_with?("#{toolchain_lib}/")
        inside_rpath_command = false
      end
      system "/usr/bin/install_name_tool", "-add_rpath", "@loader_path/../lib", bin/"periphery"
      toolchain_rpaths.uniq.each do |path|
        system "/usr/bin/install_name_tool", "-delete_rpath", path, bin/"periphery"
      end
    else
      swift_libexec_lib = Formula["swift"].opt_libexec/"lib"
      indexstore = Dir[swift_libexec_lib/"libIndexStore.so*"].map { |path| Pathname(path) }
      odie "Missing libIndexStore in #{swift_libexec_lib}" if indexstore.empty?
      indexstore.each do |path|
        lib.install path
      end

      # The binary inherits an absolute Swift toolchain rpath from the build environment.
      # Replace it with a loader-relative path so the bundled lib is used instead.
      swift_cellar_libexec_lib = Formula["swift"].libexec/"lib"
      swift_toolchain_rpaths = [swift_libexec_lib, swift_cellar_libexec_lib]
      swift_toolchain_rpaths << swift_libexec_lib.realpath if swift_libexec_lib.exist?
      swift_toolchain_rpaths << swift_cellar_libexec_lib.realpath if swift_cellar_libexec_lib.exist?
      existing_rpath = Utils.safe_popen_read(
        Formula["patchelf"].opt_bin/"patchelf", "--print-rpath", bin/"periphery"
      ).strip
      rpaths = existing_rpath.split(":").reject do |path|
        path == lib.to_s || swift_toolchain_rpaths.map(&:to_s).include?(path)
      end
      rpaths.unshift("$ORIGIN/../lib")
      system Formula["patchelf"].opt_bin/"patchelf", "--set-rpath", rpaths.uniq.join(":"), bin/"periphery"
    end

    generate_completions_from_executable(bin/"periphery", "--generate-completion-script")
  end

  test do
    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end
