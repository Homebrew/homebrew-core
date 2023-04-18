class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-8.5.9.39636.tar.gz"
  sha256 "c05f42ee791a1e8f774d2fedf03f955c3d100dda6c973f12ae00fc5c39a7a2f7"
  license "GPL-3.0-only"
  head "https://github.com/iterate-ch/cyberduck.git", branch: "master"

  livecheck do
    url "https://dist.duck.sh/"
    regex(/href=.*?duck-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "02fe98a2d36acf886983c2d7f280f8a28618e624a6a77486505bec656e8e7190"
    sha256 cellar: :any, arm64_monterey: "ec42ec56f9907feed723abf55c17af0f8f5c300336b005d45eb095274ed0f0a2"
    sha256 cellar: :any, arm64_big_sur:  "74eeb36f5c3d64bf72f5ff1e2b45c175d3ffae83593754e6b9759ed302b4a474"
    sha256 cellar: :any, ventura:        "250d5fa8c311ed4c9ff735e19ad2d3dfec964e047ca47ebeacaf42c9b2f6c896"
    sha256 cellar: :any, monterey:       "8e40cfad7d247501187f2e2e5e280a16aaac4603c959aebd2bb3e85bf21afeb7"
    sha256 cellar: :any, big_sur:        "4cbe56a6f8646eb3ac576e786aeae9280224ce2988d0e0acf4e551b35399e928"
    sha256               x86_64_linux:   "970d5058c1f1b85ea24b4cfcda066c3781d2bc6d4086d73d7169dddd7d963279"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: ["13.1", :build]
  depends_on "openjdk"

  uses_from_macos "libffi", since: :monterey # Uses `FFI_BAD_ARGTYPE`.
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrender"
    depends_on "libxtst"
  end

  resource "jna" do
    url "https://github.com/java-native-access/jna/archive/refs/tags/5.13.0.tar.gz"
    sha256 "526bff8ffcbc2067a7403f55b01ad8d7a781c098abca79c4ea6c9e80198bb5fd"
  end

  resource "rococoa" do
    url "https://github.com/iterate-ch/rococoa/archive/refs/tags/0.9.1.tar.gz"
    sha256 "62c3c36331846384aeadd6014c33a30ad0aaff7d121b775204dc65cb3f00f97b"
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

    # Set MACOSX_DEPLOYMENT_TARGET to avoid linker errors when building rococoa.
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      OTHER_LDFLAGS = -headerpad_max_install_names
      VALID_ARCHS=#{Hardware::CPU.arch}
      MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig

    resource("rococoa").stage do
      next unless OS.mac?

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
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}",
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
      rm_rf libdir/"JavaNativeFoundation.framework"
      libdir.install buildpath/"JavaNativeFoundation.framework"

      rm libdir/shared_library("librococoa")
      libdir.install buildpath/shared_library("librococoa")

      # Replace runtime with already installed dependency
      rm_r libexec/"Contents/PlugIns/Runtime.jre"
      ln_s Formula["openjdk"].libexec/"openjdk.jdk", libexec/"Contents/PlugIns/Runtime.jre"
    else
      libexec.install Dir["cli/linux/target/release/duck/*"]
    end

    rm libdir/shared_library("libjnidispatch")
    libdir.install buildpath/shared_library("libjnidispatch")
    bin.install_symlink "#{bindir}/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz", testpath/"test"
    assert_equal (testpath/"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end
