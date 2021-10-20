class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-7.10.2.35432.tar.gz"
  sha256 "8f5885799a10b0e06ed0587198dbecce63b08fa609778e84673b34faccfea40b"
  license "GPL-3.0-only"
  revision 1
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://dist.duck.sh/"
    regex(/href=.*?duck-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:      "74124ebf6531d1a01ad5d13425773c76a99e069269064637bdb27c7b66d0ae7c"
    sha256 cellar: :any, catalina:     "dac3d44df0fc024af52a6e571ea8f22d2cf570f1a2577ed510b0aaf68de3f35e"
    sha256 cellar: :any, mojave:       "673a7f8db2e85284b33c7bd06f526cf2821de441947afdfb7766772e635bc93a"
    sha256               x86_64_linux: "2409cfc228f05df6404a325f1099c8239f4d01b62c5822ddf0495dc2236f4429"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  depends_on arch: :x86_64
  depends_on "libffi"
  depends_on "openjdk"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrender"
    depends_on "libxtst"

    ignore_missing_libraries "libjvm.so"
  end

  resource "jna" do
    url "https://github.com/java-native-access/jna/archive/refs/tags/5.8.0.tar.gz"
    sha256 "97680b8ddb5c0f01e50f63d04680d0823a5cb2d9b585287094de38278d2e6625"
  end

  resource "JavaNativeFoundation" do
    url "https://github.com/apple/openjdk/archive/refs/tags/iTunesOpenJDK-1014.0.2.12.1.tar.gz"
    sha256 "e8556a73ea36c75953078dfc1bafc9960e64593bc01e733bc772d2e6b519fd4a"
  end

  def install
    # Consider creating a formula for this if other formulae need the same library
    resource("jna").stage do
      arch = "x86-64"
      os = if OS.linux?
        "Linux"
      else
        # Add linker flags for libffi because Makefile call to pkg-config doesn't seem to work properly.
        inreplace "native/Makefile", "LIBS=", "LIBS=-L#{Formula["libffi"].opt_lib} -lffi"
        # Force shared library to have dylib extension on macOS instead of jnilib
        inreplace "native/Makefile", "LIBRARY=$(BUILD)/$(LIBPFX)jnidispatch$(JNISFX)",
"LIBRARY=$(BUILD)/$(LIBPFX)jnidispatch$(LIBSFX)"

        "mac"
      end

      # Don't include directory with JNA headers in zip archive.  If we don't do this, they will be deleted
      # and the zip archive has to be extracted to get them. TODO: ask upstream to provide an option to
      # disable the zip file generation entirely.
      inreplace "build.xml",
"<zipfileset dir=\"build/headers\" prefix=\"build-package-${os.prefix}-${jni.version}/headers\" />", ""

      system "ant", "-Dbuild.os.name=#{os}", "-Dbuild.os.arch=#{arch}", "-Ddynlink.native=true", "-DCC=#{ENV.cc}",
"native-build-package"

      cd "build" do
        ENV.deparallelize
        ENV["JAVA_HOME"] = Language::Java.java_home(Formula["openjdk"].version.major.to_s)

        # Fix zip error on macOS because libjnidispatch.dylib is not in file list
        inreplace "build.sh", "libjnidispatch.so", "libjnidispatch.so libjnidispatch.dylib" if OS.mac?
        # Fix relative path in build script, which is designed to be run out extracted zip archive
        inreplace "build.sh", "cd native", "cd ../native"

        system "sh", "build.sh"
        buildpath.install shared_library("libjnidispatch")
      end
    end

    resource("JavaNativeFoundation").stage do
      if OS.mac?
        cd "apple/JavaNativeFoundation" do
          xcodebuild "VALID_ARCHS=x86_64", "-project", "JavaNativeFoundation.xcodeproj"
          buildpath.install "build/Release/JavaNativeFoundation.framework"
        end
      end
    end

    if OS.mac?
      xcconfig = buildpath/"Overrides.xcconfig"
      xcconfig.write <<~EOS
        OTHER_LDFLAGS = -headerpad_max_install_names
      EOS
      ENV["XCODE_XCCONFIG_FILE"] = xcconfig
    end

    os = if OS.mac?
      "osx"
    else
      # This changes allow maven to build the cli/linux project as an appimage instead of an RPM/DEB.
      # This has been reported upstream at https://trac.cyberduck.io/ticket/11762#ticket.
      # It has been added the version 8 milestone.
      inreplace "cli/linux/build.xml", "value=\"rpm\"", "value=\"app-image\""
      inreplace "cli/linux/build.xml", "<arg value=\"--license-file\"/>", ""
      inreplace "cli/linux/build.xml", "<arg value=\"${license}\"/>", ""
      inreplace "cli/linux/build.xml", "<arg value=\"--linux-deb-maintainer\"/>", ""
      inreplace "cli/linux/build.xml", "<arg value=\"&lt;feedback@cyberduck.io&gt;\"/>", ""
      inreplace "cli/linux/build.xml", "<arg value=\"--linux-rpm-license-type\"/>", ""
      inreplace "cli/linux/build.xml", "<arg value=\"GPL\"/>", ""

      "linux"
    end

    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}",
                  "--projects", "cli/#{os}", "--also-make", "verify"

    libdir = libexec/"Contents/Frameworks"
    bindir = libexec/"Contents/MacOS"
    if OS.mac?
      libexec.install Dir["cli/osx/target/duck.bundle/*"]
      rm_rf libdir/"JavaNativeFoundation.framework"
      libdir.install buildpath/"JavaNativeFoundation.framework"
    end

    if OS.linux?
      libdir = libexec/"lib/app"
      bindir = libexec/"bin"
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
