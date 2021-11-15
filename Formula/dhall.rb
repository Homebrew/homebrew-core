class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.40.1/dhall-1.40.1.tar.gz"
  sha256 "21c23ed7c3949f6c8adb439666a934460a07636320ae4b3dfaced03455e24e54"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eaee9b0608abaa3b1c07fdba1d17a38d865bee1b13c07d983fbd4d6f7a8f947"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5813e732f904689c01bd850dacfbadefc7cc7eabc9de698eae354f6da536487"
    sha256 cellar: :any_skip_relocation, monterey:       "8afcf38a7140334e030a4a28dc163a3efd7da193cbdbf9f85296f5a6a2169f84"
    sha256 cellar: :any_skip_relocation, big_sur:        "7419b77dbe5d0c193fee5fcc025b4498093827c49b7bb72cd5a1ea9049df2ace"
    sha256 cellar: :any_skip_relocation, catalina:       "5237942d82f12c997ed07086c1be7610ce4ba998dc87b24a3dec2d88bd382d71"
    sha256 cellar: :any_skip_relocation, mojave:         "dad39b07677cd3dc786e269a9160e938f3cdb1cdd7c35d7856293d61c7aad741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59fbea133108d39b418633a411f102ab282754d2bccb3164bc43ae2fbf9480d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
