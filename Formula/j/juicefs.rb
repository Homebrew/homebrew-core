class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "1cb3908424e210535842cfb9ab612421b2f84261acd9d9fd537b3a5ef1fd6779"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "04044d1903b67931d1ce46ef55e58696a521f4fe3255ad99604d9698f1fca71d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d63d4269fd4555c75ae5a89df14c07a75b2475e78f73e0fd32c45816a24345f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba497331d415a7313fa5283ec92f755996ab0fa360022c217bd42c626127715b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062042d599a3de2bc0af45b80cd757fdc2cbd583936f028450979e51a8fd21ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "665de5ac209bcc1f7c7227bdeb809d742294e58cec5496bd994b1653a74e8319"
    sha256 cellar: :any_skip_relocation, ventura:        "0c385ae11200e8155caaf1852540c42fc9419ce10dcee2806be884720e32330f"
    sha256 cellar: :any_skip_relocation, monterey:       "6c641718b9d934c60512d1db22f23fdcaeec5b5d58e09349c85dd9201f572efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "219adbe24922942e227aaefcbddc776f1b48eaf9e0f4f5ff77e4e81e552a93ac"
  end

  # use "go" again after https://github.com/juicedata/juicefs/issues/5047 is resolved and released
  depends_on "go@1.22" => :build

  def install
    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}/juicefs format sqlite3://test.db testfs 2>&1")
    assert_predicate testpath/"test.db", :exist?
    assert_match "Meta address: sqlite3://test.db", output
  end
end
