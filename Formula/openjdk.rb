class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  if Hardware::CPU.arm?
    # Temporarily use a openjdk 16 preview on Apple Silicon
    # (because it is better than nothing)
    url "https://github.com/openjdk/jdk-sandbox/archive/a56ddad05cf1808342aeff1b1cd2b0568a6cdc3a.tar.gz"
    sha256 "29df31b5eefb5a6c016f50b2518ca29e8e61e3cfc676ed403214e1f13a78efd5"
    version "15.0.1"
  else
    url "https://hg.openjdk.java.net/jdk-updates/jdk15u/archive/jdk-15.0.1-ga.tar.bz2"
    sha256 "9c5be662f5b166b5c82c27de29b71f867cff3ff4570f4c8fa646490c4529135a"
  end
  license :cannot_represent

  livecheck do
    url "https://hg.openjdk.java.net/jdk-updates/jdk#{version.major}u/tags"
    regex(/>\s*?jdk[._-]v?(\d+(?:\.\d+)*)-ga\s*?</i)
  end

  bottle do
    cellar :any
    sha256 "6f31366f86a5eacf66673fca9ad647b98b207820f8cfea49a22af596395d3dba" => :big_sur
    sha256 "679c34348a8ce43888280c0a9724b644e503b0476c6ef679358234845986af21" => :arm64_big_sur
    sha256 "9376a1c6fdf8b0268b6cb56c9878358df148b530fcb0e3697596155fad3ca8d7" => :catalina
    sha256 "a4f00dc8b4c69bff53828f32c82b0a6be41b23a69a7775a95cdbc9e01d9bdb68" => :mojave
    sha256 "bef2e4a43a6485253c655979cfc719332fb8631792720c0b9f6591559fb513f1" => :high_sierra
  end

  keg_only "it shadows the macOS `java` wrapper"

  depends_on "autoconf" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://download.java.net/java/early_access/jdk16/31/GPL/openjdk-16-ea+31_osx-x64_bin.tar.gz"
        mirror "https://dl.bintray.com/homebrew/mirror/openjdk-16-ea+31_osx-x64_bin.tar.gz"
        sha256 "8e4a8fdd2d965067bdb56e1a72c7c72343d571b371ac61eee74d9e71bbef63e8"
      else
        url "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_osx-x64_bin.tar.gz"
        sha256 "386a96eeef63bf94b450809d69ceaa1c9e32a97230e0a120c1b41786b743ae84"
      end
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz"
      sha256 "91310200f072045dc6cef2c8c23e7e6387b37c46e9de49623ce0fa461a24623d"
    end
  end

  unless Hardware::CPU.arm?
    # Fix build on Xcode 12
    # https://bugs.openjdk.java.net/browse/JDK-8253375
    patch do
      url "https://github.com/openjdk/jdk/commit/f80a6066e45c3d53a61715abfe71abc3b2e162a1.patch?full_index=1"
      sha256 "5320e5e8db5f94432925d7c240f41c12b10ff9a0afc2f7a8ab0728a114c43cdb"
    end

    # Fix build on Xcode 12
    # https://bugs.openjdk.java.net/browse/JDK-8253791
    patch do
      url "https://github.com/openjdk/jdk/commit/4622a18a72c30c4fc72c166bee7de42903e1d036.patch?full_index=1"
      sha256 "4e4448a5bf68843c21bf96f510ea270aa795c5fac41fd9088f716822788d0f57"
    end
  end

  # Calculate Xcode's dual-arch JavaNativeFoundation.framework path
  def framework_path
    File.expand_path("../SharedFrameworks/ContentDeliveryServices.framework/Versions/Current/itms/java/Frameworks",
                     MacOS::Xcode.prefix)
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = boot_jdk_dir/"Contents/Home"
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Inspecting .hg_archival.txt to find a build number
    # The file looks like this:
    #
    # repo: fd16c54261b32be1aaedd863b7e856801b7f8543
    # node: e3f940bd3c8fcdf4ca704c6eb1ac745d155859d5
    # branch: default
    # tag: jdk-15+36
    # tag: jdk-15-ga
    #
    # Since openjdk has move their development from mercurial to git and GitHub
    # this approach may need some changes in the future
    #
    if Hardware::CPU.arm?
      build = File.read(".hgtags")
                  .scan(/ jdk-16\+(.+)$/)
                  .map(&:first)
                  .map(&:to_i)
                  .max
      raise "cannot find build number in .hgtags" if build.nil?
    else
      build = File.read(".hg_archival.txt")
                  .scan(/^tag: jdk-#{version}\+(.+)$/)
                  .map(&:first)
                  .map(&:to_i)
                  .max
      raise "cannot find build number in .hg_archival.txt" if build.nil?
    end

    args = %W[
      --without-version-pre
      --without-version-opt
      --with-version-build=#{build}
      --with-toolchain-path=/usr/bin
      --with-boot-jdk=#{boot_jdk}
      --with-boot-jdk-jvmargs=#{java_options}
      --with-debug-level=release
      --with-native-debug-symbols=none
      --with-jvm-variants=server
      --with-sysroot=#{MacOS.sdk_path}
      --with-extra-ldflags=-headerpad_max_install_names
      --enable-dtrace
    ]

    if Hardware::CPU.arm?
      args += %W[
        --disable-warnings-as-errors
        --openjdk-target=aarch64-apple-darwin
        --with-build-jdk=#{boot_jdk}
        --with-extra-cflags=-arch\ arm64
        --with-extra-ldflags=-arch\ arm64\ -F#{framework_path}
        --with-extra-cxxflags=-arch\ arm64
      ]
    end

    chmod 0755, "configure"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    jdk = Dir["build/*/images/jdk-bundle/*"].first
    libexec.install jdk => "openjdk.jdk"
    bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/darwin/*.h"]
  end

  def post_install
    # Copy JavaNativeFoundation.framework from Xcode after install to avoid signature corruption
    if Hardware::CPU.arm?
      cp_r "#{framework_path}/JavaNativeFoundation.framework",
           "#{libexec}/openjdk.jdk/Contents/Home/lib/JavaNativeFoundation.framework",
           remove_destination: true
    end
  end

  def caveats
    s = <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
    EOS

    if Hardware::CPU.arm?
      s += <<~EOS
        This is a beta version of openjdk for Apple Silicon
        (openjdk 16 preview).
      EOS
    end

    s
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
