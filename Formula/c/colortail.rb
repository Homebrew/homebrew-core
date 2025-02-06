class Colortail < Formula
  desc "Like tail(1), but with various colors for specified output"
  homepage "https://github.com/joakim666/colortail"
  url "https://github.com/joakim666/colortail/archive/f44fce0dbfd6bd38cba03400db26a99b489505b5.tar.gz"
  version "0.3.4"
  sha256 "1f6d7c6bf088c9134946f55e1df382cde0b168600afbeeb3107a668badf3b487"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d669b41295d8cf8e288b6d319db489ded668fdec0092b33588d98e367380b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d6eebd8b255a530ea6539760bb9a2d0299ff681ca9a7b3669797b62cbb16f4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b295d551228f6fce2ab6e3e4d6f74ff7def1a153206bc88bd86c5eb56fd0d6ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5a0495e09bf2e179708a32610fc388bbb85603d634ee3a6bb5fd8f2effc92f1"
    sha256 cellar: :any_skip_relocation, ventura:       "c0377e036c34c4751921735b0cb1d5246e6e5fb787cb3f7a79ae6857a5ea41a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa418e94d26b6b470e6f936a18cc61a18d064a52a3be518d9d6b575b214bbb9d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Upstream PR to fix the build on ML
  patch do
    url "https://github.com/joakim666/colortail/commit/36dd0437bb364fd1493934bdb618cc102a29d0a5.patch?full_index=1"
    sha256 "d799ddadeb652321f2bc443a885ad549fa0fe6e6cfc5d0104da5156305859dd3"
  end

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello\nWorld!\n"
    assert_match(/World!/, shell_output("#{bin}/colortail -n 1 test.txt"))
  end
end
