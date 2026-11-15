class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://www.gnustep.org/"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_31_1/gnustep-base-1.31.1.tar.gz"
  sha256 "e7546f1c978a7c75b676953a360194a61e921cb45a4804497b4f346a460545cd"
  license "GPL-2.0-or-later"
  revision 4
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8f9a8d57bc18bb6f2da416deaec2df707e89979a7b73811f7fabc2605c98de5e"
    sha256 cellar: :any, arm64_tahoe:       "b737d6b89bd089eb3fc35b05fee93a33487768c14c1fe29857e899df95f35e2a"
    sha256 cellar: :any, arm64_sequoia:     "4b963c6b12be222eb24d90ab874bfce04ae0b8049088c63d423d14165fc8da91"
    sha256 cellar: :any, arm64_linux:       "387fc3d7f0244c3f3a1e88be1a40432df0fccb5783bdd1f809c8ec9a1113c32e"
    sha256 cellar: :any, x86_64_linux:      "412706d13d9a42340210cba245e6624e54fa2accc37e6449181b480bae16de40"
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
    depends_on "icu4c@79"
  end

  on_linux do
    depends_on "libobjc2"
    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  fails_with :gcc do
    cause "GCC Objective-C support is insufficient"
  end

  patch do
    url "https://github.com/gnustep/libs-base/commit/bace6f54fd5fb882cb3adc79c87cc82d5c6d9c70.patch?full_index=1"
    sha256 "7b8a8a4465c5807ff6df48a23b9a3085eaa7ff0fef44bf8aeb4c7d9d05df10bf"
    type :backport
    resolves "https://github.com/gnustep/libs-base/issues/589"
  end

  deny_network_access!

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("gnustep-make")
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      formula_opt_prefix("gnustep-make")/"Library/GNUstep/Makefiles"
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
