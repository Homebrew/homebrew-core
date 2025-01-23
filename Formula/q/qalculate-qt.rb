class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.5.0/qalculate-qt-5.5.0.tar.gz"
  sha256 "e7e97b2fb6fde836eae2e7bc4249d54cd5ecac13c00e56188de0c21664fb4086"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "37caa473c2b48e5e6bd3c498ce5d2ca638192adff0cfe72599c33f4731d8d374"
    sha256 cellar: :any,                 arm64_ventura: "e2ad4002f02e22d166a3af195e6892678ba8e7c7eed08f2eee30ac6bbc64db02"
    sha256 cellar: :any,                 sonoma:        "e14797dec296ea99cb35a501eed70e86e6c8c5ff2de57006b673fffe3dd581fb"
    sha256 cellar: :any,                 ventura:       "676d648e392041cf859e3caa1905ffdbbd108d04fa53cd5b5a33cd619f2530e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e07f18e15d0b528dadf060a42c4326c1a096317e479fabf43a3bf5efe60c0f"
  end

  depends_on "pkgconf" => :build

  depends_on "libqalculate"
  depends_on "qt"

  on_macos do
    depends_on "gmp"
    depends_on "mpfr"
  end

  def install
    system Formula["qt"].bin/"qmake", "qalculate-qt.pro"
    system "make"
    if OS.mac?
      prefix.install "qalculate-qt.app"
      bin.install_symlink prefix/"qalculate-qt.app/Contents/MacOS/qalculate-qt" => "qalculate-qt"
    else
      bin.install "qalculate-qt"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match version.to_s, shell_output("#{bin}/qalculate-qt -v")
  end
end
