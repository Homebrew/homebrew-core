class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"
  revision 1

  bottle do
    cellar :any
    sha256 "c8f2755fd775064c282da84d666336d9125c6e70082975ffdc0867dee60b5802" => :high_sierra
    sha256 "3ab40020a258be907f829205952a3336f424c0de4588fe41c5859e8c16ebaf72" => :sierra
    sha256 "0d699de535a558e1bc72811f0b0ac7ccc158ee224564ff8e4d0b959c5872a9dc" => :el_capitan
    sha256 "c36b7219ff6d838884d8fbe13a1d159b5375e5868b9a9c0d84de332952549e36" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build

  def install
    inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    # Fix outdated SYSROOT to avoid:
    # No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/...'
    inreplace "pm_common/CMakeLists.txt",
              "set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE",
              "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

    system "make", "-f", "pm_mac/Makefile.osx"
    system "make", "-f", "pm_mac/Makefile.osx", "install"

    cd "pm_python" do
      # There is no longer a CHANGES.txt or TODO.txt.
      inreplace "setup.py" do |s|
        s.gsub! "CHANGES = open('CHANGES.txt').read()", 'CHANGES = ""'
        s.gsub! "TODO = open('TODO.txt').read()", 'TODO = ""'
      end
      # Provide correct dirs (that point into the Cellar)
      ENV.append "CFLAGS", "-I#{include}"
      ENV.append "LDFLAGS", "-L#{lib}"

      ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end
end
