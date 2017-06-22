class MrubyCli < Formula
  desc "Build native command-line applications for Linux, MacOS, and Windows"
  homepage "https://github.com/hone/mruby-cli"
  url "https://github.com/hone/mruby-cli/archive/v0.0.4.tar.gz"
  sha256 "97d889b5980193c562e82b42089b937e675b73950fa0d0c4e46fbe71d16d719f"

  def install
    ENV["MRUBY_CLI_LOCAL"] = "true"
    rewrite_build_config
    system "rake", "compile"
    cp "mruby/build/host/bin/mruby-cli", "mruby-cli"
    bin.install "mruby-cli"
  end

  # The upstream build_config.rb assumes it will be compiled on Linux.
  # It also automatically cross compiles to MacOS, Linux, and Windows
  # This configuration compiles a single MacOS binary using clang
  def rewrite_build_config
    build_config = <<-eos
      MRuby::Build.new do |conf|
        toolchain :clang

        conf.gem File.expand_path(File.dirname(__FILE__))
      end
    eos

    File.open("build_config.rb", "w") do |f|
      f.write(build_config)
    end
  end

  test do
    system "#{bin}/mruby-cli", "-v"
  end
end
