class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "http://programming.nu"
  url "https://github.com/timburks/nu/archive/v2.2.0.tar.gz"
  sha256 "c7489c9dad1e24ee6cf7e70e5c31f4c891aba0793e8a00c4fc7e6b23d96fccc4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8c15fe6d9ec3f4a857a1c5948e784fc7b963e1336abeb6eafd0eb48144a6524e" => :sierra
    sha256 "6db4fa8bafc2110e16cb7b8ae675e4e25483cb3d05b7f15535ae3cabe25f48d2" => :el_capitan
    sha256 "6934ad8b4e7a1baa21939975a82b5fb2b4ec8d7462bb9c4237004dd10c05d9d4" => :yosemite
    sha256 "c6075aa6a0ea3a36067295f9e9e16fca5ec0d4c79db5f7c5fde19e774a24f69e" => :mavericks
  end

  depends_on :macos => :lion
  depends_on "pcre"

  fails_with :gcc do
    build 5666
    cause "nu only builds with clang"
  end

  def install
    ENV.delete("SDKROOT") if MacOS.version < :sierra
    ENV["PREFIX"] = prefix

    inreplace "Nukefile" do |s|
      s.gsub!('(SH "sudo ', '(SH "') # don't use sudo to install
      s.gsub!("\#{@destdir}/Library/Frameworks", "\#{@prefix}/Frameworks")
      s.sub! /^;; source files$/, <<-EOS
;; source files
(set @framework_install_path "#{frameworks}")
EOS
    end
    system "make"
    system "./mininush", "tools/nuke"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "./mininush", "tools/nuke", "install"
  end

  def caveats; <<-EOS.undent
    Nu.framework was installed to:
      #{frameworks}/Nu.framework

    You may want to symlink this Framework to a standard macOS location,
    such as:
      ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
  EOS
  end

  test do
    system bin/"nush", "-e", '(puts "Everything old is Nu again.")'
  end
end
