class Far2l < Formula
  desc "Linux port of FAR v2"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/alpha-02nov18.tar.gz"
  version "0.2-alpha"
  sha256 "971d170698d9567d28c547ba5d49234f6d0f9e5b1dece0ab366037daea87e675"
  head "https://github.com/elfmz/far2l.git"

  depends_on "cmake" => :build
  depends_on "gawk"
  depends_on "glib"
  depends_on "pkg-config"
  depends_on "wget"
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install", "DESTDIR=#{prefix}"
    mkdir_p bin.to_s
    (bin/"far2l").write <<~EOS
      #!/usr/bin/env bash
      "#{prefix}/usr/bin/far2l"
    EOS
  end
end
