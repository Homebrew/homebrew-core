class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.3.2/fdupes-2.3.2.tar.gz"
  sha256 "808d8decbe7fa41cab407ae4b7c14bfc27b8cb62227540c3dcb6caf980592ac7"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4b36f431443bb485436062a901736cf32d5300ad54a727a8686344b98a0439c3"
    sha256 cellar: :any,                 arm64_sonoma:   "3e61741f1fad31c0d9a30944d32a8097474bfb50b8cfcb892dea68252a9d5799"
    sha256 cellar: :any,                 arm64_ventura:  "16f9f0943dd140f6c91acfae645b3d911aba4526613a130c21fa275f9be4ce06"
    sha256 cellar: :any,                 arm64_monterey: "dea22eee9147298c50e3e41d930c869effc6a99b9a2e20d25b270e069ff58f41"
    sha256 cellar: :any,                 sonoma:         "43a2ae20a78911bff4710314601bb5369bc6f615f46efb2d6013b518937eb926"
    sha256 cellar: :any,                 ventura:        "933ac3a985ebbfcfc34402d6579cf8f1694b93395192e953a618173027f4fa58"
    sha256 cellar: :any,                 monterey:       "13c75942d279704a1556dbc9f3bbe8052594a7c3cdd09fd6deae4e68f0342f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52b7e8485e9933e6d3154d07908b0f433d8dd3b611f6b078d7fdf077b18a6350"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
