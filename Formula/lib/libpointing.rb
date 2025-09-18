class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "https://github.com/INRIA/libpointing"
  url "https://github.com/INRIA/libpointing/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "697581d27101c9816f1b19715e7ace85a5345857d65e4eaa82840cf2051435d6"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "77cf45ea25e9ccec41d9be73e28da4d1c2568d9ab42000ba543e1d904853f6ed"
    sha256 cellar: :any,                 arm64_sequoia:  "fc963b2d475b92c4a7fd7a525d0ae301cedad7c825d50bd47f1e174be955ab51"
    sha256 cellar: :any,                 arm64_sonoma:   "2d7abf099808b966f2e79ff4ee050ae9ba2dcaa009577575a8ceceeb657e3cda"
    sha256 cellar: :any,                 arm64_ventura:  "79773a252a784d765237674545e3355bec847c95f9ac82cc89826936954f8990"
    sha256 cellar: :any,                 arm64_monterey: "777a0f897878a4da3693f9d8a5717f42ff70fc281a81b57b4841a31ce17e7100"
    sha256 cellar: :any,                 arm64_big_sur:  "19de172dd9ad6744f9939955a5c526d3626400727631cdd07a6e22d8791fbf48"
    sha256 cellar: :any,                 sonoma:         "ca321e413ebc04effeb4c54ee765a9954eccfed31df4111413480826429ca5d2"
    sha256 cellar: :any,                 ventura:        "97732d46ffab874e21adbaeaf3a6953df026772565ccfa5dcb5f5d51378ac75e"
    sha256 cellar: :any,                 monterey:       "9fad8e2c767cc76679b49546cf443a0ec1d7b7115dbd82faaff20649b3b77ff4"
    sha256 cellar: :any,                 big_sur:        "e9168eee924fc759e012e3ef41d64750d732f0d09a7af068fd935746835da472"
    sha256 cellar: :any,                 catalina:       "d56d66f5df0d6e1c80cc4e4951e8add9cbb0c5fb76080c9107f66665b8b46e48"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ffb598217e1da31c8150b384ff7a88d6afdb3c5980edf11f7422033ca5bb2972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb26145aac1e2fa3a1a552c8120a5f2f6fbd0fb7b9836dfccdbbaaeec7e161c"
  end

  uses_from_macos "python" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "systemd"
  end

  def install
    # Fix packaging scripts to be compatible with Python 3
    scripts = %w[building-and-packaging/linux/prepare building-and-packaging/mac/prepare]
    inreplace scripts do |s|
      s.gsub! "#!/usr/bin/env python", "#!/usr/bin/env python3"
      s.gsub! ": print >> fd, TEST_PROG\n", ": print(TEST_PROG, file=fd)\n"
      s.gsub!(/print >> makefile, (.*)\n/, "print(\\1, file=makefile)\n")
      s.gsub! "print >> makefile\n", "print(\"\", file=makefile)\n"
    end

    ENV.cxx11
    platform = OS.mac? ? "mac" : "linux"
    cd "building-and-packaging/#{platform}" do
      ENV["LIBPOINTING_VERSION"] = version
      system "./prepare"
      subdir = OS.mac? ? version : "dist"
      system "make", "-C", "libpointing-#{subdir}"
      system "make", "-C", "libpointing-#{subdir}", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pointing/pointing.h>
      #include <iostream>
      int main() {
        std::cout << LIBPOINTING_VER_STRING << " |" ;
        std::list<std::string> schemes = pointing::TransferFunction::schemes() ;
        for (std::list<std::string>::iterator i=schemes.begin(); i!=schemes.end(); ++i) {
          std::cout << " " << (*i) ;
        }
        std::cout << std::endl ;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lpointing", "-o", "test"
    system "./test"
  end
end
