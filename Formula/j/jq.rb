class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.7/jq-1.7.tar.gz"
  sha256 "402a0d6975d946e6f4e484d1a84320414a0ff8eb6cf49d2c11d144d4d344db62"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe0e7ed9a1407256a50afe7f49af6018f450a6e2bf04d47eafec60f1f63111ac"
    sha256 cellar: :any,                 arm64_ventura:  "976b252c6a3f6dfa2531ee1459718ab7a8338ac4fb84edacd6f6d55743713a16"
    sha256 cellar: :any,                 arm64_monterey: "c702eade07a9a6914fc3aa075d89ccca3afc2d4ea77bee895f233ca4479e570d"
    sha256 cellar: :any,                 arm64_big_sur:  "d121938e0e87bd80584f6b452b29ac22cde7acca0b15ed3e91f8fd1d3c9014eb"
    sha256 cellar: :any,                 sonoma:         "8d0493297afbb4ae6131c51e4eed0369cf3aaacf0f845f6cca078b6201a7288b"
    sha256 cellar: :any,                 ventura:        "e4b23ebcff759f57e62e2573359ccb62e8e3426a1237082bf3301843230d3094"
    sha256 cellar: :any,                 monterey:       "748e1d8825d2961e082d412583e6e7b6e60ad75408325e976516c0db266720fe"
    sha256 cellar: :any,                 big_sur:        "0edbe8f1792bd794762018699592fe24d4aac01a2de369a4c4a4e25b96bc213f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dfc7c926478acd7652b60300155adf5df9a0afbb4f9fe1a838793529d968ca0"
  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
