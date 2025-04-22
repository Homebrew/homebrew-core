class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20250116.tgz"
  sha256 "1500d41224d50b72728ccafe23c4ee096bc8535fd6fdb9e876da4cdeeddadc83"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c2fa00f2063a7ba61733a6ec514717782466e6b8a811cb036ddb727f149c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59549c5e8a296ffef736c269b98d386ddeb1c358740cd5b49b3bd50bd4543b69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "628ee30b6aecd244ca816a1dd314b7dcf2b3e483a2a03395464b4c4b1aa19793"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a330d5624273363729084fb7cfe703f85c26c0f38d6fb882497f43cf59614f"
    sha256 cellar: :any_skip_relocation, ventura:       "e60ad33c06a155538e2f1713150c303893b3f77d5b930c1e126a390fc77f73fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a020afff86107c179aeb9d6fb0d4eccc5e909243a53995c4ffb0a5fe037e9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "317ee8c5ae7ba4069672d9b89b2c22ad07432b5e071133118405444d48b6f003"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
