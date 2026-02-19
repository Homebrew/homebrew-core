class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "https://linukz.org/cd-discid.shtml"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/taem/cd-discid.git", branch: "master"

  stable do
    url "https://linukz.org/download/cd-discid-1.4.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
    sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"

    # macOS fix; see https://github.com/Homebrew/homebrew/issues/46267
    # Already fixed in upstream head; remove when bumping version to >1.4
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/cd-discid/1.4.patch"
      sha256 "f53b660ae70e91174ab86453888dbc3b9637ba7fcaae4ea790855b7c3d3fe8e6"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6296e37d4a08d066d58baffa8ea53abf75c592f126ffcee9418ef293a9528a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9956c0cddca69b3a816e8bc553c0455adac71f67ee30041a9065ac7c4384c219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6714fb89edba30f77536f171b99da060ec3fa80a419a0f27f5ab2b9a26f2a266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "618a12cac73126b2818a93e91870571b7c78604ac0c4ab4e9f93e6c398a9d33a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "671ac240cb3b94484690d12ec1d85cc96d90ffbf848cfb4adeebd8f5f32c1fbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7effbc8d5fb1325aa629f1ec607d75c64c9547b0aa70deb4f05b07e5a6b94c84"
    sha256 cellar: :any_skip_relocation, sonoma:         "2627114d338684f14e54e6cdeac94b9eecd648e45b7328c33ed86c98edd26abb"
    sha256 cellar: :any_skip_relocation, ventura:        "29d889c70841d76b9e01b6d2ab4d482fd7ee7e8ac67ba36a4720b457444f48b1"
    sha256 cellar: :any_skip_relocation, monterey:       "d90c6640e3b67fb2140a10da27714f30a302187bb0f0b13477a53936a2a66456"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ffa8010d3a9ebbd8475901bca190ed9fe786ff7b9ff32ff161347b10ecd87fd"
    sha256 cellar: :any_skip_relocation, catalina:       "0a9f85136e9727175a4d861f759236d62cf24f19170e27bfd9bf8aeddbc4c8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "92144152a7fa53e3cbe4c6eced912ab7a569079a1d40fb9a72c73635f70027c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e37cc61545d58bebb66ffffada804ca5e39e47e503684c7ed84cfa856dbb14"
  end

  # Last commit was 9 years ago, upstream site is gone
  deprecate! date: "2025-10-16", because: :unmaintained

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end
