class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_29_0/gnustep-base-1.29.0.tar.gz"
  sha256 "fa58eda665c3e0b9c420dc32bb3d51247a407c944d82e5eed1afe8a2b943ef37"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 cellar: :any,                 arm64_sonoma:   "1d7c91e904aa5235b936237af89844760b564e4bb70cbeed16e56c52cc0ece2a"
    sha256 cellar: :any,                 arm64_ventura:  "a236ad4dc35176d4eec9ebf0ed1225872d20393fae0498e8f4e79949ebcf183b"
    sha256 cellar: :any,                 arm64_monterey: "3df755b603ab766f02ab0834ae23fce53fbadcc53b51ab61c2dadb8931f79cd8"
    sha256 cellar: :any,                 sonoma:         "ff59b43b7be6606c4a7935aececd9ff22e74fbd55f3d54677ed98a2909b9b223"
    sha256 cellar: :any,                 ventura:        "af2aa5f19a5e72f97950209d0a8abfcbb3333af30c572f5c0a8e6cb55db5db37"
    sha256 cellar: :any,                 monterey:       "3c1091a0f232597717754dbad8417a1877bc4fc8e68347b4de03d3c0eb7c5624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb071ced655073c8386129648bfbb806d2ee382ef1579e46dcdaf25cea88ecd"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "llvm" => :build
  uses_from_macos "icu4c", since: :monterey
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libobjc2"
    fails_with :gcc
  end

  # Fix build with new libxml2.
  # https://github.com/gnustep/libs-base/pull/295
  patch do
    url "https://github.com/gnustep/libs-base/commit/37913d006d96a6bdcb963f4ca4889888dcce6094.patch?full_index=1"
    sha256 "57e353fedc530c82036184da487c25e006a75a4513e2a9ee33e5109446cf0534"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix/"Library/GNUstep/Makefiles"
    else
      Formula["gnustep-make"].share/"GNUstep/Makefiles"
    end

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      ENV["ICU_CFLAGS"] = "-I#{sdk}/usr/include"
      ENV["ICU_LIBS"] = "-L#{sdk}/usr/lib -licucore"

      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share/"GNUstep/Makefiles"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install", "GNUSTEP_HEADERS=#{include}",
                              "GNUSTEP_LIBRARY=#{share}",
                              "GNUSTEP_LOCAL_DOC_MAN=#{man}",
                              "GNUSTEP_LOCAL_LIBRARIES=#{lib}",
                              "GNUSTEP_LOCAL_TOOLS=#{bin}"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS

    assert_match "Validation failed: no DTD found", shell_output("#{bin}/xmlparse test.xml 2>&1")
  end
end
