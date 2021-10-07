class Cantata < Formula
  desc "Qt5 Graphical MPD Client"
  homepage "https://github.com/CDrummond/cantata"
  url "https://github.com/CDrummond/cantata/archive/v2.4.2.tar.gz"
  sha256 "6d2e18200fb4e268dbacacf0e5a3a674fe1a3517ad6708c02dc829c2ffb1d3ba"
  license "GPL-3.0-or-later"
  head "https://github.com/CDrummond/cantata.git", branch: "master"

  depends_on "cmake" => :build
  # Enable optional support for MTP devices.
  depends_on "libmtp" => :build
  depends_on "qt@5" => :build
  # Enable optional support for tag editing and track organization.
  depends_on "taglib" => :build

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5"

  def install
    if OS.mac?
      cd "mac" do
        system "./createicon.sh"
      end
    end

    ENV["Qt5_DIR"] = Formula["qt@5"].opt_lib/"cmake"
    ENV.prepend_path "CMAKE_PREFIX_PATH", Formula["qt@5"].opt_lib/"cmake/Qt5Widgets"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink prefix/"Cantata.app/Contents/MacOS/cantata" if OS.mac?
  end

  def caveats
    <<~EOS
      Cantata.app was installed to:
        #{opt_prefix}
    EOS
  end

  test do
    assert_match "cantata #{version}", shell_output("#{bin/"cantata"} -v ")
  end
end
