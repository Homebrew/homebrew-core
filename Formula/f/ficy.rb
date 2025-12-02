class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "https://www.thregr.org/wavexx/software/fIcy/"
  url "https://www.thregr.org/wavexx/software/fIcy/releases/fIcy-1.0.21.tar.gz"
  sha256 "8564b16d3a52fa6dc286b02bfcc19e4acdc148c30f1750ca144e2ea47c84fd81"
  license "LGPL-2.1-only"
  head "https://gitlab.com/wavexx/fIcy.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?releases/fIcy[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a229e2cdd5d347698dba54b95b66a0a17db438be849e798ba7b2c82ca4db924d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a74c5666c5779883383e3e98926f165056a5c2b1c4489c344390c8cea1700354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80755ff2ff4f5143809aaa0bc23f8a999337cb583add0ccc3271cf464eb32def"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1886cf04ca32f5bdde1f3bc5489ac636cfdaabcf8ea7ef2a4a902e7b2a91843c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c25a3ab155e4dea715aa37ef9fc544adc571300c67aab77e93fb66423337052a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586d692ab7b64ad5805d51280e78ef997bf0ad2ebd1db2ed57ddc05b126f950b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fee05645b50006a82bd985781fdac941a7c1b7797a243014c8b864eee0d47b43"
    sha256 cellar: :any_skip_relocation, ventura:        "ef2563d59bf9e6e918bf73928c2002d3d5e75f57f97e9fa24140c7dac10f0d17"
    sha256 cellar: :any_skip_relocation, monterey:       "b6eeba4f52cc614eca8a65cae2f346d41e2e0376f27459fdede8e7eb82ef7a12"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb6228a79e94bd6a6d37ec647da5b0ca1863ba03992d93bed90071858d0be55e"
    sha256 cellar: :any_skip_relocation, catalina:       "9974dd8c30bcfe482222a8e6f4040c6c5ccb21c7ef6b893dbbf3033f7e5a85ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5b077fa05c6e598149b0bf1b7c7d2bc098d7712be5b1857d1c52ecb289689c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b055098e6bef712df9dbcf449f550b5e9b47d9b5ddbda657815f224dd2326bb"
  end

  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system bin/"fResync", "-n", "1", "test.mp3"
  end
end
