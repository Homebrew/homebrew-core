class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-9.1.4.43177.tar.gz"
  sha256 "96d5447320dd094d1c37d70a8631e321f966dc927179c8b01638c33baf502795"
  license "GPL-3.0-only"
  head "https://github.com/iterate-ch/cyberduck.git", branch: "master"

  livecheck do
    url "https://dist.duck.sh/"
    regex(/href=.*?duck(?:-src)?[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8452b267b2b6dc5b7f897bdd936630b4c20c74c98514089c3e7d1ea5424ad4f3"
    sha256 cellar: :any, arm64_sonoma:  "4b22313f07172072e458c058e7f1038d7a4d58593bc8e0ac126ab62f5a51c304"
    sha256 cellar: :any, arm64_ventura: "139577fa21c0828e6f5b8881455282a0771289300ea91310ee10bef1d3d9f356"
    sha256 cellar: :any, sonoma:        "f942a951a01b823e6247b178b0da78bdab9094113cc858ddff68c1986c91def9"
    sha256 cellar: :any, ventura:       "9ba954249bc79a8afc1a55cc475fbafd13485f405007dc964fb033526bba9ee3"
    sha256               arm64_linux:   "95f1978f010a3009a79b9b381e59531b536b43f836e3acb3a1cf7a785165d3c9"
    sha256               x86_64_linux:  "d55145d694a6e3094243cdc1e4df1826b49cf5e1834fafbc4693f3a5432ce0a5"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: ["13.1", :build]
  depends_on "openjdk"

  uses_from_macos "libffi", since: :monterey # Uses `FFI_BAD_ARGTYPE`.
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "giflib"
    depends_on "harfbuzz"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "little-cms2"
  end

  conflicts_with "duckscript", because: "both install `duck` binaries"

  resource "jna" do
    url "https://github.com/java-native-access/jna/archive/refs/tags/5.17.0.tar.gz"
    sha256 "fe35d85e63ea998ec08f1beaa0162b1e7f233e9e82b8f43ba500a0a824874158"
  end

  resource "rococoa" do
    url "https://github.com/iterate-ch/rococoa/archive/refs/tags/0.10.0.tar.gz"
    sha256 "8ce789a7b27c37ed37dcb6517b76de8eee144bf7269c3c645d791f21c20a3046"
  end

  resource "JavaNativeFoundation" do
    url "https://github.com/apple/openjdk/archive/refs/tags/iTunesOpenJDK-1014.0.2.12.1.tar.gz"
    sha256 "e8556a73ea36c75953078dfc1bafc9960e64593bc01e733bc772d2e6b519fd4a"
  end

  def install
    # Consider creating a formula for this if other formulae need the same library
    resource("jna").stage do
      os = if OS.mac?
        inreplace "native/Makefile" do |s|
          libffi_libdir = if MacOS.version >= :monterey
            MacOS.sdk_path/"usr/lib"
          else
            Formula["libffi"].opt_lib
          end
          # Add linker flags for libffi because Makefile call to pkg-config doesn't seem to work properly.
          s.change_make_var! "LIBS", "-L#{libffi_libdir} -lffi"
          library_var = s.get_make_var("LIBRARY")
          # Force shared library to have dylib extension on macOS instead of jnilib
          s.change_make_var! "LIBRARY", library_var.sub("JNISFX", "LIBSFX")
        end

        "mac"
      else
        OS.kernel_name
      end

      # Don't include directory with JNA headers in zip archive.  If we don't do this, they will be deleted
      # and the zip archive has to be extracted to get them. TODO: ask upstream to provide an option to
      # disable the zip file generation entirely.
      inreplace "build.xml",
                "<zipfileset dir=\"build/headers\" prefix=\"build-package-${os.prefix}-${jni.version}/headers\" />",
                ""

      system "ant", "-Dbuild.os.name=#{os}",
                    "-Dbuild.os.arch=#{Hardware::CPU.arch}",
                    "-Ddynlink.native=true",
                    "-DCC=#{ENV.cc}",
                    "native-build-package"

      cd "build" do
        ENV.deparallelize
        ENV["JAVA_HOME"] = Language::Java.java_home(Formula["openjdk"].version.major.to_s)

        inreplace "build.sh" do |s|
          # Fix zip error on macOS because libjnidispatch.dylib is not in file list
          s.gsub! "libjnidispatch.so", "libjnidispatch.so libjnidispatch.dylib" if OS.mac?
          # Fix relative path in build script, which is designed to be run out extracted zip archive
          s.gsub! "cd native", "cd ../native"
        end

        system "sh", "build.sh"
        buildpath.install shared_library("libjnidispatch")
      end
    end

    resource("JavaNativeFoundation").stage do
      next unless OS.mac?

      cd "apple/JavaNativeFoundation" do
        xcodebuild "VALID_ARCHS=#{Hardware::CPU.arch}",
                   "OTHER_CFLAGS=-Wno-strict-prototypes", # Workaround for Xcode 14.3
                   "-project", "JavaNativeFoundation.xcodeproj"
        buildpath.install "build/Release/JavaNativeFoundation.framework"
      end
    end

    resource("rococoa").stage do
      next unless OS.mac?

      # Set MACOSX_DEPLOYMENT_TARGET to avoid linker errors when building rococoa.
      xcconfig = buildpath/"Overrides.xcconfig"
      xcconfig.write <<~EOS
        OTHER_LDFLAGS = -headerpad_max_install_names
        VALID_ARCHS=#{Hardware::CPU.arch}
        MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
      EOS
      ENV["XCODE_XCCONFIG_FILE"] = xcconfig

      cd "rococoa/rococoa-core" do
        xcodebuild "VALID_ARCHS=#{Hardware::CPU.arch}", "-project", "rococoa.xcodeproj"
        buildpath.install shared_library("build/Release/librococoa")
      end
    end

    os = if OS.mac?
      "osx"
    else
      OS.kernel_name.downcase
    end

    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dconfiguration=default", "-Dgit.commitsCount=#{revision}",
                  "--projects", "cli/#{os}", "--also-make", "verify"

    libdir, bindir = if OS.mac?
      %w[Contents/Frameworks Contents/MacOS]
    else
      %w[lib/app bin]
    end.map { |dir| libexec/dir }

    if OS.mac?
      libexec.install Dir["cli/osx/target/duck.bundle/*"]

      # Remove the `*.tbd` files. They're not needed, and they cause codesigning issues.
      buildpath.glob("JavaNativeFoundation.framework/**/JavaNativeFoundation.tbd").map(&:unlink)
      rm_r(libdir/"JavaNativeFoundation.framework")
      libdir.install buildpath/"JavaNativeFoundation.framework"

      rm libdir/shared_library("librococoa")
      libdir.install buildpath/shared_library("librococoa")

      # Replace runtime with already installed dependency
      rm_r libexec/"Contents/PlugIns/Runtime.jre"
      ln_s Formula["openjdk"].libexec/"openjdk.jdk", libexec/"Contents/PlugIns/Runtime.jre"
    else
      libexec.install Dir["cli/linux/target/default/duck/*"]
    end

    rm libdir/shared_library("libjnidispatch")
    libdir.install buildpath/shared_library("libjnidispatch")
    bin.install_symlink "#{bindir}/duck" => "duck"
  end

  test do
    system bin/"duck", "--download", "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz", testpath/"test"
    assert_equal (testpath/"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end
