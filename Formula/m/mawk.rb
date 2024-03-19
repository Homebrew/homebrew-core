class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20240123.tgz"
  sha256 "a8e319a83744b1f1fb6988dfa189d61887f866e9140cc9a49eb003b2b0655e88"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87cdbd179ee1d059becf026dedaf803f58d967b323f74ff3eb846532231f118f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "057db0aa8e071e3f22ac5bae73d91f3260f1a313fbf3546e82337563313aad85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999282dc0302c6edc8b63ff4d4fbc590d6bc718e48736b4c5d0f21fc9f16c4be"
    sha256 cellar: :any_skip_relocation, sonoma:         "0398aec6314c7a30855a0c5d3ba958dc21b81fbe33c6d1c2f9e403278bd7a1a7"
    sha256 cellar: :any_skip_relocation, ventura:        "e52b3d6b5be1915a08cb43d49152ffa897d0ced32615f5b4c5a49e235a043529"
    sha256 cellar: :any_skip_relocation, monterey:       "5978bbc4cfcf2f229e2e7ae1ec7d3f1209e4802c503c014cdd382a22bffae66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ea58859198dbd4b5b250b79c134a6a40251e08ec8b69c50d67fd24432bc638d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
