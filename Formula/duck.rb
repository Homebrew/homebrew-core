class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-8.3.3.37544.tar.gz"
  sha256 "32d7b3e966e4faf6572b30bd145b3512e651346ead93ada0c2eab25583e4ed8b"
  license "GPL-3.0-only"
  head "https://github.com/iterate-ch/cyberduck.git", branch: "master"

  livecheck do
    url "https://dist.duck.sh/"
    regex(/href=.*?duck-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "29e3f8d998840469e75e7af21ddd01b4f2558e6afc0bd7d82ed1610826951f24"
    sha256 cellar: :any, arm64_big_sur:  "8873b7e4e404163fb21debe081ca70b3ccf916edb375938de94973d0d44a2840"
    sha256 cellar: :any, monterey:       "e240ea1095e0899289b23a2ca1d30d7c5fcaccb34a0cf8e4e7a08f422dc676a7"
    sha256 cellar: :any, big_sur:        "07ef97553917d1aa6b8efa26e152357157ba4747c81dac87a9b2c214d8de8561"
    sha256 cellar: :any, catalina:       "05ffcb0af3937c2500e95b6b993e08b7f0294f916d689cab38ac719a57cf8507"
    sha256               x86_64_linux:   "dbbccd269003ec06cac286f7a825f21b6e1fe99c3efeab8930eb161f4545e057"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

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
    url "https://github.com/java-native-access/jna/archive/refs/tags/5.10.0.tar.gz"
    sha256 "6ef63cbf6ff7c8eea7d72331958e79c9fd3635c987ce419c9f296db6c4fd66a4"
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
        # Add linker flags for libffi because Makefile call to pkg-config doesn't seem to work properly.
        inreplace "native/Makefile", "LIBS=", "LIBS=-L#{Formula["libffi"].opt_lib} -lffi"
        # Force shared library to have dylib extension on macOS instead of jnilib
        inreplace "native/Makefile",
                  "LIBRARY=$(BUILD)/$(LIBPFX)jnidispatch$(JNISFX)",
                  "LIBRARY=$(BUILD)/$(LIBPFX)jnidispatch$(LIBSFX)"

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

        # Fix zip error on macOS because libjnidispatch.dylib is not in file list
        inreplace "build.sh", "libjnidispatch.so", "libjnidispatch.so libjnidispatch.dylib" if OS.mac?
        # Fix relative path in build script, which is designed to be run out extracted zip archive
        inreplace "build.sh", "cd native", "cd ../native"

        system "sh", "build.sh"
        buildpath.install shared_library("libjnidispatch")
      end
    end

    resource("JavaNativeFoundation").stage do
      next unless OS.mac?

      cd "apple/JavaNativeFoundation" do
        xcodebuild "VALID_ARCHS=#{Hardware::CPU.arch}", "-project", "JavaNativeFoundation.xcodeproj"
        buildpath.install "build/Release/JavaNativeFoundation.framework"
      end
    end

    resource("rococoa").stage do
      next unless OS.mac?

      cd "rococoa/rococoa-core" do
        xcodebuild "VALID_ARCHS=#{Hardware::CPU.arch}", "-project", "rococoa.xcodeproj"
        buildpath.install shared_library("build/Release/librococoa")
      end
    end

    os = if OS.mac?
      xcconfig = buildpath/"Overrides.xcconfig"
      xcconfig.write <<~EOS
        OTHER_LDFLAGS = -headerpad_max_install_names
        VALID_ARCHS=#{Hardware::CPU.arch}
      EOS
      ENV["XCODE_XCCONFIG_FILE"] = xcconfig

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
