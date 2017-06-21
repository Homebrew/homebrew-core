class MrubyCli < Formula
  desc "Build native command-line applications for Linux, MacOS, and Windows"
  homepage "https://github.com/hone/mruby-cli"
  url "https://github.com/hone/mruby-cli/archive/v0.0.4.tar.gz"
  sha256 "97d889b5980193c562e82b42089b937e675b73950fa0d0c4e46fbe71d16d719f"

  # The mruby-cli build_config.rb assumes that it will be compiled on Linux.
  # It also automatically cross compiles to MacOS, Linux, and Windows
  # This patch compiles a single MacOS binary using clang
  patch do
    url "https://gist.githubusercontent.com/jeremyjung/ca4f5baa0e6567b96332b6a9281ab37b/raw/84d9dc64fbe02162cab5625243d7e477adb32ab3/mruby-cli_patch.diff"
    sha256 "4d148001ac180c1942f157829d5a18e553987fc370b5d98d9f1123ce3b21436f"
  end

  def install
    ENV["MRUBY_CLI_LOCAL"] = "true"
    system "rake", "compile"
    cp "mruby/build/host/bin/mruby-cli", "mruby-cli"
    bin.install "mruby-cli"
  end

  test do
    system "#{bin}/mruby-cli", "-v"
  end
end
