class Multitime < Formula
  desc "Time command execution over multiple executions"
  homepage "https://tratt.net/laurie/src/multitime/"
  url "https://github.com/ltratt/multitime/archive/refs/tags/multitime-1.4.tar.gz"
  sha256 "31597066239896ee74a3aaaea3b22931a50a1ec1470090c5457ef35500c44249"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "44ade5e6e48db9bd18070d63223cc2f93bf359e9ff41d0007e2c528f045d672f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f8212bee01aa77f3422303f6ff1d0e59bb2937be070934a857448e808adaa61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0439477342bced6548a46765025a9d860d571060b9319dfe480f977b8420e0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "013f3d84765b886e4a877466669328c4ba0f8214ad2b9c97285fee79cfecaad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c38266c2518cac8687617b0d4b96171b56a179b8472ff4bd3145b2d6ddc9d0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52335b15831a687d6b1bf9ef67de299b3295143181ea0d9511b437a69362b385"
    sha256 cellar: :any_skip_relocation, sonoma:         "5aefa64c4517d2b0e29cf18db79425dbca79d44bcb0f4a42482e5a63edfbd057"
    sha256 cellar: :any_skip_relocation, ventura:        "6feb3f1f7d7bba11c73aa2abcb2abfe882541da4a2dcf6800ea75c836ab41483"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a9f7932ea6baa734272e31bca733b4f481b1c401959e51432195ef1abf3c80"
    sha256 cellar: :any_skip_relocation, big_sur:        "c744099831fd19d36e44e055b880803715fe570b7fd8b7879054ed83706b2625"
    sha256 cellar: :any_skip_relocation, catalina:       "ae01126fe74b8bb90f45b901a5e92665e6b392a5dad3af356313dae5835f70da"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "043f63a6abf6942c5c312f0d2eb1fed48931f54ba6fc2695f9e6c81c8dfe27f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da1f67a4f35c418aaf3d63eb3afdeaea4ffbbba2465e68628d80b6e37464f26"
  end

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "autoheader"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/multitime -n 2 sleep 1 2>&1")
    assert_match(/((real|user|sys)\s+([01].\d{3}\s*){5}){3}/m, output)
  end
end
