class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "http://programming.nu"
  url "https://github.com/timburks/nu/archive/v2.2.2.tar.gz"
  sha256 "7b1de5062ba2a87ee4cbf458f5f851a3c43473eec8aae3e17704e0dd4ff56b39"

  bottle do
    cellar :any
    sha256 "1508d2c0376f54e1108568f79fa907244877f1d3981bbe6db69c6efcc7460c54" => :sierra
    sha256 "183c89418f6803a6f1395545739da9012b4e049d160038d6d5c00e242243284a" => :el_capitan
    sha256 "ba5bd173433144dbf6141cfced1c04f17f81c1cb014ea2f794090e6c5a5f8f4b" => :yosemite
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
