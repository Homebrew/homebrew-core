class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.3.0/fdupes-2.3.0.tar.gz"
  sha256 "6170d64a7e565ee314cca4dd25a123e60aa1e3febb11e57078bebb9c1da7e019"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "897dbe95ed16fa2cd4cbc77667366cbff8867282b893aef8be0132cfc92bc111"
    sha256 cellar: :any,                 arm64_ventura:  "4d14de46b007fdb7ed70cb8f21a11c68380aae85d19c40209f677e941cc85181"
    sha256 cellar: :any,                 arm64_monterey: "204b75405b8a2658dd421ba15fe21699d5e9a884cc5101b838cd76bf4b8b2fec"
    sha256 cellar: :any,                 sonoma:         "fdd5097a173103da07f92505d269c3112e8a1f098b137a1e1c4f439fe1c22caf"
    sha256 cellar: :any,                 ventura:        "96610d287eb04fa9e6804cd4f397dd09cb8619f71e95ebda1e5cecf091394702"
    sha256 cellar: :any,                 monterey:       "69b273615ffbc6215d6cc66d3d617f43c7d1b448d7fc3bad453c9df3b0c30ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfd928d203104c25d21012fde115e095c03091fe5d05c30de22d7a66311bfbc"
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
