class Dosfstools < Formula
  desc "Tools to create, check and label file systems of the FAT family"
  homepage "https://github.com/dosfstools"
  license "GPL-3.0-or-later"
  head "https://github.com/dosfstools/dosfstools.git", branch: "master"

  stable do
    url "https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz"
    sha256 "64926eebf90092dca21b14259a5301b7b98e7b1943e8a201c7d726084809b527"

    # remove in next release
    # https://github.com/dosfstools/dosfstools/pull/166
    patch do
      url "https://github.com/dosfstools/dosfstools/commit/77ffb87e8272760b3bb2dec8f722103b0effb801.patch?full_index=1"
      sha256 "ecbd911eae51ed382729cd1fb84d4841b3e1e842d08e45b05d61f41fbd0a88ff"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d54a1407f985fc34279f07ead09aa53ae0cbe1a24b8a7328d4cbcb8fb24d9c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a865f34d1361ac215e3ec359fd524e4ee92ea63cac75ccaac99298c871aa4b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "574e8d06c7e0cfd4c57b7d3187a7ba4b0d59a4162e6550e5f49afcfb9de8090d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40a3ed816a04a4104a60aa95f8ae76bee9be12872e8147c0a41fa3f879f11ced"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41e7da04f31a04e5ad7fc460b9c15b6526780fab0de0339fcdea540dfbaec964"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d8437b8921385c7675d2502c0c7b746f060e6b1656923e061173d568927f34d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b06025314c13c2f4d2c1e8c2af272bfed50dcb51f2845ff12e19485851b78ba"
    sha256 cellar: :any_skip_relocation, ventura:        "134a64a971297ad37b2635532916116f6350c3771c03efa6ea3da259bb260ce1"
    sha256 cellar: :any_skip_relocation, monterey:       "e288a32bae22472eb31806afad3a025220d7284ddf6cdbf5b48a196ec5831139"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4f450bef47449fa57d911e1c3610cd65bf8d7fd661e3efc8a0a44c7d45510f5"
    sha256 cellar: :any_skip_relocation, catalina:       "df9afee3d6ec3da028a6fdd487b98800099f8aa248261c35ed2821e984b91a70"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0f175df17e208a3e33de63fa36168da5daff1fe7a5ae61be6e7e140838171b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584daa5a52ed21b3b23eba4323ebec3fa8421062c9cac5d833e60b91da0a7636"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  def install
    # Workaround for https://github.com/dosfstools/dosfstools/pull/218
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-compat-symlinks",
                          "--without-udev",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=test.bin", "bs=512", "count=1024"
    system sbin/"mkfs.fat", "test.bin", "-n", "HOMEBREW", "-v"
    system sbin/"fatlabel", "test.bin"
    system sbin/"fsck.fat", "-v", "test.bin"
  end
end
