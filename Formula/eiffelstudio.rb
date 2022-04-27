class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/19.05/eiffelstudio-19.05.10.3187.tar"
  sha256 "b5f883353405eb9ce834c50a863b3721b21c35950a226103e6d01d0101a932b3"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "247ae6f6d6c9a15fb568d7a67150ed74f75b7718fff8391f746f5fae89adce54"
    sha256 cellar: :any, big_sur:       "aeb6b50791dc52a1911e04309f88a37ffbc597ae077124cbcdd983366c2d02f7"
    sha256 cellar: :any, catalina:      "a75094bbba27a570e33d7efb5136526da56a8328c0177ad7ca4dff6e217ba49e"
    sha256 cellar: :any, mojave:        "8a7764d27dccc50a8bd8d34175591c90bd52ef8c3e3bf256a941cfccbd0e7f84"
    sha256 cellar: :any, high_sierra:   "1204b20cd8146aeb89dc15b904ee792cfe6dd7141bc30536beba436efa667cea"
    sha256 cellar: :any, sierra:        "4f8f7374ec1a2032334dd13ddf00d93b3feda22c75d884f7c0f8fe799f27643b"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  uses_from_macos "pax" => :build

  def install
    # Fix flat namespace usage in C shared library.
    if OS.mac?
      system "tar", "xf", "c.tar.bz2"
      inreplace "C/CONFIGS/macosx-x86-64", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      system "tar", "cjf", "c.tar.bz2", "C"
    end

    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    os_tag = "#{os}-x86-64"
    system "./compile_exes", os_tag
    system "./make_images", os_tag
    prefix.install Dir["Eiffel_19.05/*"]
    eiffel_env = { ISE_EIFFEL: prefix, ISE_PLATFORM: os_tag }
    {
      studio:       %w[ec ecb estudio finish_freezing],
      tools:        %w[compile_all iron syntax_updater],
      vision2_demo: %w[vision2_demo],
    }.each do |subdir, targets|
      targets.each do |target|
        (bin/target).write_env_script prefix/subdir.to_s/"spec"/os_tag/"bin"/target, eiffel_env
      end
    end
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system bin/"ec", "-version"
  end
end
