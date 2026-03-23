class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_31_1/gnustep-base-1.31.1.tar.gz"
  sha256 "e7546f1c978a7c75b676953a360194a61e921cb45a4804497b4f346a460545cd"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0693816f992adcfc685d2ee8464599a92a51bfb60a8fc428b7a41f77b6657266"
    sha256 cellar: :any,                 arm64_sequoia: "ea087ac117a4ddee94f9ab38f7bff0e307b80b2cba871be2009711a234a54d11"
    sha256 cellar: :any,                 arm64_sonoma:  "23da697180c63dec9c9690536bb3debe66b6d78c19ef0ce507571ab2436c8bac"
    sha256 cellar: :any,                 sonoma:        "35f3f0a775c9e8f138a46ede7e827b2017dc00f4ff60338da1e2eb433d942a58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ca2baa3e217b0325cb5a5d8544abda7eda57237c21b50cecf04719c68773a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d1ac8a92a0cfe7ad301988d5018efa6e8f71f2a906723304dab14ba0448a33"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "llvm" => :build
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_system :linux, macos: :big_sur_or_older do
    depends_on "icu4c@78"
  end

  on_linux do
    depends_on "libobjc2"
    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  fails_with :gcc do
    cause "GCC Objective-C support is insufficient"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix/"Library/GNUstep/Makefiles"
    else
      Formula["gnustep-make"].share/"GNUstep/Makefiles"
    end

    if OS.mac? && MacOS.version > :big_sur && (sdk = MacOS.sdk_path)
      ENV["ICU_CFLAGS"] = "-I#{sdk}/usr/include"
      ENV["ICU_LIBS"] = "-L#{sdk}/usr/lib -licucore"

      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share/"GNUstep/Makefiles"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install", "GNUSTEP_HEADERS=#{include}",
                              "GNUSTEP_LIBRARY=#{share}",
                              "GNUSTEP_LOCAL_DOC_MAN=#{man}",
                              "GNUSTEP_LOCAL_LIBRARIES=#{lib}",
                              "GNUSTEP_LOCAL_TOOLS=#{bin}"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    XML

    assert_match "Validation failed: no DTD found", shell_output("#{bin}/xmlparse test.xml 2>&1")
  end
end
