class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.5.0.tar.gz"
  sha256 "07e18ce606feb8c86a1f79f7f5dd724079ac27196faa61a2cefa5b599bbb5bb1"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6fa91fb368a63d5558b8c287b330845e04f90bd4fe7223e161493b01747c869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c0c8c0b35c1c5faa2a71fc0bd088725f5623f465369dcca5b2cea59322714c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2314abe4aae7ea53660920d311cacccd168045994e1a9eddf12a381b215c1908"
    sha256 cellar: :any_skip_relocation, ventura:        "d132d06243b93952309f3fbe1970d87cde272ea103cf1829c880c1b8a85a12cb"
    sha256 cellar: :any_skip_relocation, monterey:       "86111a102d0782a77bab0d48015bd275f120a36964d86f8f613f1a8f73d94664"
    sha256 cellar: :any_skip_relocation, big_sur:        "d622cfe1d925f0058f583b8bf48b0bdcee36a441f1bcf145040e5f93879f8765"
    sha256 cellar: :any_skip_relocation, catalina:       "5d9d495ec8215cfade3e856528dfa233496849517813b19a9ba8d60cb72c4751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbff5503f74ef5dcaae33846e285ecf1a23c23de1c858760ae1789ef6fc99524"
  end

  depends_on "go" => :build

  def install
    system "go", "generate" if build.head?
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    bash_completion.install "completion.d/aptly"
    zsh_completion.install "completion.d/_aptly"

    man1.install "man/aptly.1"
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
