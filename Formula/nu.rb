class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "http://programming.nu"
  url "https://github.com/timburks/nu/archive/v2.2.1.tar.gz"
  sha256 "0657f203a01906983480f5e599199afc6fe350c3da94376d594ef04b5faef2df"

  bottle do
    cellar :any
    sha256 "f8ece82e0e6953a6146cff31a3758896119cc9984190d94a7a8e5e6eaa4f6062" => :sierra
    sha256 "8dd2d00bb135201774ef6a1c8ca54711d77e835170368ac6a82d2f008ea9cbc5" => :el_capitan
    sha256 "6582e9e393f82aa0936941602cd82f1a1546f6a602e57599330c5b5930296e39" => :yosemite
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
