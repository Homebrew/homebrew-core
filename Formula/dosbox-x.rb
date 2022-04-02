class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.24.tar.gz"
  sha256 "f4746f1524cac58756123c7acbbc565e215d7f298a19667fd845dbba040c6021"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a984c3c2a245bb5d8de54e130d0f4a4d5a5310c1d2de01d805e54844fd777c19"
    sha256 cellar: :any, arm64_big_sur:  "c680218a908629e4693ef2c0c391f851be73db66c37e72f681ef494ed81c1618"
    sha256 cellar: :any, monterey:       "e172480c57b0ce656b418aa5efc26534f1b303f5e1f26bd44368801e19df222a"
    sha256 cellar: :any, big_sur:        "41faca6a5b569f295efcecde34cca6a419f759b9e69996ed3567f41a7d110420"
    sha256 cellar: :any, catalina:       "9d5b415e05834a05d2cc3f9031172c55b33e6a028b499bd775ee0082ad8afd9d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
