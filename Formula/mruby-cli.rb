class MrubyCli < Formula
  desc "Build native command-line applications for Linux, MacOS, and Windows"
  homepage "https://github.com/hone/mruby-cli"
  url "https://github.com/hone/mruby-cli/archive/v0.0.4.tar.gz"
  sha256 "97d889b5980193c562e82b42089b937e675b73950fa0d0c4e46fbe71d16d719f"

  def install
    ENV["MRUBY_CLI_LOCAL"] = "true"

    # Edit config to skip building Linux and Windows binaries
    rm buildpath/"build_config.rb"

    (buildpath/"build_config.rb").write <<-EOS.undent
      MRuby::Build.new do |conf|
        toolchain :clang
        conf.gem File.expand_path(File.dirname(__FILE__))
      end
    EOS

    system "rake", "compile"
    bin.install "mruby/build/host/bin/mruby-cli"
  end

  test do
    system "#{bin}/mruby-cli", "--setup=brew"
    assert File.file? "brew/mrblib/brew.rb"
    assert File.file? "brew/tools/brew/brew.c"
  end
end
