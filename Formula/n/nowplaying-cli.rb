class NowplayingCli < Formula
  desc "Retrieves currently playing media, and simulates media actions"
  homepage "https://github.com/kirtan-shah/nowplaying-cli"
  url "https://github.com/kirtan-shah/nowplaying-cli/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "bb49123c66282b6495c245589313afc94875a7b0e82c9ae9f79d6f25e7503db4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "652c94eaf2850ecceee1e133439af0c303aff3b4f8ac7a56c6b18f9d09049acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1a4b77d57e7d151e6fc408096e76e2f6273a0187e974778bec58ff4417dac115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "028c91c0152017e30caa8f006961034ad91faedb2f92fb76d9d3a724775bf2a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d98330f2152a1dd02ecc8a515f5ff56d2e780196e705a8367275d8ce043552c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fbe78e350e35164e78a14b0cb853143c00824c612813d4cdd78afaa1675709e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bdf6c603add430676f621c00b5d6c944819fb0851cb419dacda90eae42bcb43"
    sha256 cellar: :any_skip_relocation, ventura:        "0d06f10462257cfd5c96e7e029db043499d9fffae9cb6f843714e7e115dc4288"
    sha256 cellar: :any_skip_relocation, monterey:       "4a6d9fdc2681a4912562186b4ee2c0965e56c0ec2c9189314afb505424745bb3"
  end

  # see upstream discussion, https://github.com/kirtan-shah/nowplaying-cli/issues/28
  deprecate! date: "2026-04-17", because: :unmaintained

  depends_on :macos

  def install
    system "make"
    bin.install "nowplaying-cli"
  end

  test do
    assert_equal "(null)", shell_output("#{bin}/nowplaying-cli get-raw").strip
  end
end
