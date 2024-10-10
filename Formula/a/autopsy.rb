class Autopsy < Formula
  desc "Graphical interface to Sleuth Kit investigation tools"
  homepage "https://www.autopsy.com/"
  url "https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.21.0/autopsy-4.21.0.zip"
  sha256 "49228e6e5d6ecbfb6da8362c18df0ddfe86691556a461bfdbe2a8963088c5a24"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/autopsy[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dbb4291f1325784e67d172ee19b80d1557ae45ee1e0cc9be8da5e1baf0b08374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b7daff147ae1d82a0dee7c5f3d853b0b6015af1bf2fde65f23676feae1b7895"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7daff147ae1d82a0dee7c5f3d853b0b6015af1bf2fde65f23676feae1b7895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "778ab6721c38acce97a7e7bbe7e4c941ecb9c8f6a684581e26d2b24684308046"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "778ab6721c38acce97a7e7bbe7e4c941ecb9c8f6a684581e26d2b24684308046"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd85ba9a96870da9470b8119649d1da48daa5bae273b0ef726535dac9dd4f5f0"
    sha256 cellar: :any_skip_relocation, ventura:        "fb630d6b19ab15e8688b7fe1b59bfd708dd6d0366cc9c29a40a33ecf6c9c4b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, catalina:       "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, mojave:         "cec5acab1fcc5e79f07962e85ed00af7696fb5db6d7e1bce164d8f21bf3b614d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1ce8b5147639d7737a4013030ee2a059d1b8dd4657554e08e9423a9a6b2f66"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "openjdk"
  depends_on "sleuthkit"
  depends_on "testdisk"
  depends_on "zlib"

  resource "autopsy-src" do
    url "https://github.com/sleuthkit/autopsy/archive/refs/tags/autopsy-4.21.0.tar.gz"
    sha256 "044d8466edb995c619ef310a6ca0a2216cb5c63d32395b718aea129bab78649c"
  end

  def install
    rm_r(Dir["**/*.{cmd,dll,exe}", "platform/modules/lib/{aarch64,i386,riscv64}"])
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/*"]

    # Ensure correct zlib linkage
    zlib_dir = Formula["zlib"].opt_lib
    ENV.prepend "LDFLAGS", "-L#{zlib_dir}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["zlib"].opt_include}"

    # Perform setup based on https://github.com/sleuthkit/autopsy/blob/develop/unix_setup.sh
    java_home = Language::Java.java_home
    inreplace libexec/"etc/autopsy.conf", /^#jdkhome=.*$/, "jdkhome=\"#{java_home}\""
    sleuthkit_jar = "sleuthkit-#{Formula["sleuthkit"].version}.jar"
    (libexec/"autopsy/modules/ext"/sleuthkit_jar).unlink
    (libexec/"autopsy/modules/ext").install_symlink Formula["sleuthkit"].opt_share/"java"/sleuthkit_jar
    chmod "+x", libexec.glob("autopsy/markmckinnon/{Export,parse}*")
    chmod "+x", libexec.glob("autopsy/solr/bin/**/*")
    chmod "+x", libexec/"bin/autopsy"

    # Rebuild binaries with broken linkage
    modules_libdir = libexec/"autopsy/modules/lib"
    if Hardware::CPU.arm?
      # Remove non-native binaries for arm64
      rm_r(libexec/"autopsy/markmckinnon/Export_srudb_macos")
      rm_r(libexec/"autopsy/markmckinnon/parse_prefetch_macos")
      rm_r(libexec/"platform/modules/lib/x86_64/libjnidispatch-nb.jnilib")
    else
      %w[x86_64 amd64].each do |arch|
        (modules_libdir/arch/"libheifconvert.dylib").unlink
        (modules_libdir/arch/"libheifconvert.so").unlink
      end
    end
    resource("autopsy-src").stage do
      ENV["JAVA_HOME"] = java_home
      system "cmake", "-S", "thirdparty/libheif/HeifConvertJNI", "-B", "build",
                      "-DCMAKE_INSTALL_BINDIR=.",
                      *std_cmake_args(install_prefix: libexec/"autopsy/modules/lib/x86_64", install_libdir: ".")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
    (modules_libdir/"amd64").install_symlink modules_libdir/"x86_64"/shared_library("libheifconvert")
  end

  test do
    # Launch autopsy inside a PTY and use Ctrl-C to exit it.
    PTY.spawn(bin/"autopsy") do |_r, w, _pid|
      w.write "\cC"
    end
  end
end
