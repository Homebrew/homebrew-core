class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  if Hardware::CPU.arm?
    # Temporarily use a openjdk 17 preview on Apple Silicon (because it is better than nothing).
    # See https://openjdk.java.net/jeps/391
    url "https://github.com/openjdk/jdk/archive/dbc9e4b50cdda35f5712deaf440c49f50b9edc96.tar.gz"
    sha256 "e1b22e612d55dd94942df84e1457edb06a4536bed5903fdc8091026f041bf888"
    version "15.0.3"
  else
    url "https://github.com/openjdk/jdk15u/archive/refs/tags/jdk-15.0.3-ga.tar.gz"
    sha256 "3cf4cb3bb6320e50fdfd0fa8552cd53651a7dad8cff0f443adffef89d703d219"
  end
  license :cannot_represent

  livecheck do
    url "https://hg.openjdk.java.net/jdk-updates/jdk#{version.major}u/tags"
    regex(/>\s*?jdk[._-]v?(\d+(?:\.\d+)*)-ga\s*?</i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "063189cdbad2c9ef5ab5e7dc34cea1d2fe68a5405b3728eb87765d6c1b9a3a64"
    sha256 cellar: :any, big_sur:       "13e7d2b43989b42f0af448ac08fc8ecca1e643ed69e16a9b5f7efdde79d4b23d"
    sha256 cellar: :any, catalina:      "fca110fb6caad1228156b587a3ca9fa9ab5a0d423dee554e9f57b07081c3aac5"
    sha256 cellar: :any, mojave:        "25b541c2de04a0ccbe55a2c53ce1c1de32ae0da23e162ecb38ca3ecda630efd9"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on xcode: :build if Hardware::CPU.arm?

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      if Hardware::CPU.arm? # Oracle doesn't shipped JDK for Apple Silicon yet, so use Zulu JDK 16 for bootstrapping.
        url "https://cdn.azul.com/zulu/bin/zulu16.30.15-ca-jdk16.0.1-macosx_aarch64.tar.gz"
        sha256 "47f50e9c120130a77a77e65ccdb4ca4e101fe662bb429ba95668811c8618ab67"
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

  def install
    # Path to dual-arch JavaNativeFoundation.framework from Xcode
    framework_path = File.expand_path(
      "../SharedFrameworks/ContentDeliveryServices.framework/Versions/Current/itms/java/Frameworks",
      MacOS::Xcode.prefix,
    )

    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = boot_jdk_dir/"Contents/Home"
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Inspecting .hgtags to find a build number
    # The file looks like this:
    #
    # 1613004c47e9dc867a2c2c43d716533b1aaedc5f jdk-15.0.2+0
    # cc4fdb537bc14734064a9a8eadb091fd1c12b36e jdk-15.0.2+1
    # d24e907486b3f90691980b0dde01efca5840abc6 jdk-15.0.2+2
    # dbb11e11955ad1240ba775ab0007a14547e14ce6 jdk-15.0.2+3
    # 4c4a2eb7b19ecb31620e6bb120e40f8a5fd1737a jdk-15.0.2+4
    # e431a9461b1356c4b763443e5333b3f4a8695eaf jdk-15.0.2+5
    # d5977ee56509ceaa3d3c8e1aebbca76651358da4 jdk-15.0.2+6
    # 38912b2a5bcb396c75f8707e300773c874327451 jdk-15.0.2+7
    #
    # Since openjdk has move their development from mercurial to git and GitHub
    # this approach may need some changes in the future
    #
    version_to_parse = if Hardware::CPU.arm?
      "17"
    else
      version
    end
    build = File.read(".hgtags")
                .scan(/ jdk-#{version_to_parse}\+(.+)$/)
                .map(&:first)
                .map(&:to_i)
                .max
    raise "cannot find build number in .hgtags" if build.nil?

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

    if Hardware::CPU.arm?
      dest = libexec/"openjdk.jdk/Contents/Home/lib/JavaNativeFoundation.framework"
      # Copy JavaNativeFoundation.framework from Xcode
      # https://gist.github.com/claui/ea4248aa64d6a1b06c6d6ed80bc2d2b8#gistcomment-3539574
      cp_r "#{framework_path}/JavaNativeFoundation.framework", dest, remove_destination: true

      # Replace Apple signature by ad-hoc one (otherwise relocation will break it)
      system "codesign", "-f", "-s", "-", "#{dest}/Versions/A/JavaNativeFoundation"
    end
  end

  def caveats
    on_macos do
      s = <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
      EOS

      if Hardware::CPU.arm?
        s += <<~EOS
          This is a beta version of openjdk for Apple Silicon
          (openjdk 17 preview).
        EOS
      end

      s
    end
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
