class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_29_0/gnustep-base-1.29.0.tar.gz"
  sha256 "fa58eda665c3e0b9c420dc32bb3d51247a407c944d82e5eed1afe8a2b943ef37"
  license "GPL-2.0-or-later"

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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "273c97c299a8d34bf80b954842dd6de55d0ee7a266bb695a56263bd30635c72d"
    sha256 cellar: :any,                 arm64_ventura:  "ff0405fbcd2a5e29820f8aac1cf935ad8c5be93748b6bfd5877297547730561a"
    sha256 cellar: :any,                 arm64_monterey: "fbc3b491c2c32046aeefd0edfc35c9404b33fb15f9273870cab2ee1f8838ed34"
    sha256 cellar: :any,                 sonoma:         "8e710f26da4ef956b00ed4866241417fb564e043d961ae27e96afb4fce1056e0"
    sha256 cellar: :any,                 ventura:        "2476f8486238e778203cce03eda32586e86ee9b83467963dbd19ea508b44fae0"
    sha256 cellar: :any,                 monterey:       "72669da078dd6a7b10336e57c22ccd6fb7a2310bbd11cb93a1105c7e81c6fbe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ccc5dba4ab5903e9ddb6472edc04a38903032779f6fbc1b5702e9e7547cae44"
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
