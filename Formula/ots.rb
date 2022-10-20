class Ots < Formula
  desc "🔐 Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https://ots.sniptt.com"
  url "https://github.com/sniptt-official/ots/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "77101725c2f88a67ec6e4a076c232826c4af265cf0c1348c388ccedcbc4c6492"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9788b2ce207870f97e65976033fd03c054a4cc46c6c7dba6964e8e4e742ba131"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "635be319cc5753d67c4dab692e3212f373fecad88460573792257695e16e35a8"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1e1386261311f8ff50579dd727dd781941b43f2f0783fffbbc3cd034815a32"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd0a411552adec7443195beba4185d5a3e391f9288bc504fc522dbaec7648ff7"
    sha256 cellar: :any_skip_relocation, catalina:       "2998b92d46b5ce403a80c06455436febe2e516fbfa498b7540a477b9518b1d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a52a1261153c3d031518000dbb700c45f588b1efd0c2f53d622cda91ded0ac2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sniptt-official/ots/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}/ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end
