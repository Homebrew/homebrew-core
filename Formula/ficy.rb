class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "https://www.thregr.org/~wavexx/software/fIcy/"
  url "https://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.21.tar.gz"
  sha256 "8564b16d3a52fa6dc286b02bfcc19e4acdc148c30f1750ca144e2ea47c84fd81"
  license "LGPL-2.1-only"
  head "https://gitlab.com/wavexx/fIcy.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?releases/fIcy[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c25a3ab155e4dea715aa37ef9fc544adc571300c67aab77e93fb66423337052a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586d692ab7b64ad5805d51280e78ef997bf0ad2ebd1db2ed57ddc05b126f950b"
    sha256 cellar: :any_skip_relocation, monterey:       "b6eeba4f52cc614eca8a65cae2f346d41e2e0376f27459fdede8e7eb82ef7a12"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb6228a79e94bd6a6d37ec647da5b0ca1863ba03992d93bed90071858d0be55e"
    sha256 cellar: :any_skip_relocation, catalina:       "9974dd8c30bcfe482222a8e6f4040c6c5ccb21c7ef6b893dbbf3033f7e5a85ab"
    sha256 cellar: :any_skip_relocation, mojave:         "01d1a72a131cb19375bc8a068a59759d3207a60c84a4772cd8d52641ae1f8b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b055098e6bef712df9dbcf449f550b5e9b47d9b5ddbda657815f224dd2326bb"
  end

  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/fResync", "-n", "1", "test.mp3"
  end
end
