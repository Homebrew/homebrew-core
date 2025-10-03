class Dfc < Formula
  desc "Display graphs and colors of file system space/usage"
  homepage "https://github.com/Rolinh/dfc"
  url "https://github.com/Rolinh/dfc/releases/download/v3.1.1/dfc-3.1.1.tar.gz"
  sha256 "962466e77407dd5be715a41ffc50a54fce758a78831546f03a6bb282e8692e54"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Rolinh/dfc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "7a89f0d391fc36d847a8385ade4caee48ac0ee3edac6fd460dfd05f89bd5996f"
    sha256 arm64_sequoia:  "2d84a8c3886281129fbe28c532fd87e12ab4b03d49d69490183122851b57cb2b"
    sha256 arm64_sonoma:   "7096f36097e668255f157e287ef43387c5ca35d2e80bb0677e0f63eb647c4f55"
    sha256 arm64_ventura:  "3a7c3a4bb6e644fb06bc3b28dcce2f2a61a2be235cb65e4a188bf55a63657c43"
    sha256 arm64_monterey: "6aa0c0d2ad81bf179b61fced051ea22e5cb85376eafbb8e1d7376d8f3fc9cec7"
    sha256 arm64_big_sur:  "6f2d7350e0c7e1c905718b6dcf282367bc846bbd51538a9a525f681dda03be61"
    sha256 sonoma:         "0a60ac19f9bb91969d13895b18def28e2bfabdc8f20521428a4e62566175cbda"
    sha256 ventura:        "fefbde9ea38d983a69c406f0ed63ceecdea1460fa34d97ca64a158b86da1f2f2"
    sha256 monterey:       "127dd250819075427ca4a6f35f292d29c4af8b070c6ee368645817d54ac5a50b"
    sha256 big_sur:        "a89714cadb5ca91708c9f0c0f37266726517418e0ee592003c1cff38cc7599b1"
    sha256 catalina:       "cefa6f0f5e96a815ebbee4d4618dc927f88052f4137d52c31d21688fac211aa8"
    sha256 arm64_linux:    "210935ed2e087198b582b8c46b02bd88c0f95df0cc996b17310e38e56a711fcf"
    sha256 x86_64_linux:   "0d467920d7e3393975fc11b8fa07f84e177ddafdfa7139bc219183380f891d42"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dfc", "-T"
    assert_match ",%USED,", shell_output("#{bin}/dfc -e csv")
  end
end
