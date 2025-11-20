class Ipinfo < Formula
  desc "Tool for calculation of IP networks"
  homepage "https://kyberdigi.cz/projects/ipinfo/"
  url "https://kyberdigi.cz/projects/ipinfo/files/ipinfo-1.2.tar.gz"
  sha256 "19e6659f781a48b56062a5527ff463a29c4dcc37624fab912d1dce037b1ddf2d"
  license "Beerware"

  # The content of the download page is generated using JavaScript and software
  # versions are the first string in certain array literals in the page source.
  livecheck do
    url :homepage
    regex(/(?:new Array\(|\[)["']v?(\d+(?:\.\d+)+)["'],/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "97ebf675a6aa3fd914b342df26584eaded1d0d5b7b31ff4a8d2531ad61ab9152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ff62045518304b036f380fb7a14218208349858d1d1b5db7d39c3877e1361400"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4284a229bc38e71cb7ccd08df9056a350eb2e7a47b224e3f567eb8f4ec79d0fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48870fd5a3ee495bbc62c79d5706403ccef08c28f00d503b7bd661315bf2016c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36096abf98dc91542e89ef61e240b9470d7b4203d721f18d9e0021a0bc373e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c631709cb3810dbbef8f37e1b2d7c76fb301ae36bb9b2d63885ecde62152b7ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea99afca3cdf9fa28fdb6a72a72b4d094716c2a10d06ee22d7c558328673454f"
    sha256 cellar: :any_skip_relocation, ventura:        "b6200ef7097f9b8deaf0b7c28b968e6af3577e22a38345fccc859c89ded033b1"
    sha256 cellar: :any_skip_relocation, monterey:       "dd6a283e541551be0bda8e82d322dc5f057e363021482cb8111afd0d045d6924"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b70f868f6a9a1c2e59247a09510e14e3da1a45c2acaa86fde9b93a155a14e68"
    sha256 cellar: :any_skip_relocation, catalina:       "b2202f465e419b0bc7e3667d75247cc37a46b49d9a4eb5f23f1f63cb361fd366"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7281f5fe0d2f917996b4049beb1753c4c4e22a808d9fbbdc3b1905c37365be70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91632022aa7d392d7f03002052683ca4d7bc9d09b16a6132d479b7263dd2969f"
  end

  conflicts_with "ipinfo-cli", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "make", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    system bin/"ipinfo", "127.0.0.1"
  end
end
