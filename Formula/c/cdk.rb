class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20240331.tgz"
  sha256 "8c5d7c6138ae3d76cf149027e1b10a6727c52fd0a7177fca934436890bb0f2de"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03908f895b719b35db718c2cee9ea5c434d99909ff52044dc2c8ebc261fbb069"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "218f46ab1c0cfc19496eff513c0970bb983fd06ce66b97582591239aceb80b54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d96b596cd5d533a300d70167fc0002a46f3648b5fabbe375e5e56e58bd10e415"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7c323e5ff0a34fa3be8d0de48de361a087d3a1f63552ef765b009a03f7d672e"
    sha256 cellar: :any_skip_relocation, ventura:        "12bb1e4e4528bbb90e5c7a1b2beb09b442ebe5c568005162e4879dffb45d122b"
    sha256 cellar: :any_skip_relocation, monterey:       "549a16f365eb7bfd13bd9adfc79e95a7c2ac09be7c9824ceb5d47c36f76a305d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c490689dbaea2d75ceb73895743bd0d995c3bca28f501dcadcb7e292330246"
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
