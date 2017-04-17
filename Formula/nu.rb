class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "http://programming.nu"
  url "https://github.com/timburks/nu/archive/v2.2.1.tar.gz"
  sha256 "0657f203a01906983480f5e599199afc6fe350c3da94376d594ef04b5faef2df"

  bottle do
    cellar :any
    sha256 "87367b6358fb87348481108ad0192b9a9342274150cdfaec84701eca3031d222" => :sierra
    sha256 "ed030bbe40655e3a44c4e3becd5775b5ab25d1d32070c2f0a85bfde3769ff44a" => :el_capitan
    sha256 "c13703832378165f06c8d333b9c9272520e4412e6d8ee8598cbb3e4a01144ddd" => :yosemite
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
