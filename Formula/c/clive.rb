class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "808d05ba49c827a449117fc80082bf7df7708e9c46db630364fc292f239165b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7992bc1cfebdd02d7c0251f115485d9bc11f7062dc2eb91c3f48199bd3120e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7992bc1cfebdd02d7c0251f115485d9bc11f7062dc2eb91c3f48199bd3120e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7992bc1cfebdd02d7c0251f115485d9bc11f7062dc2eb91c3f48199bd3120e7"
    sha256 cellar: :any_skip_relocation, ventura:        "61a1ab51613a33005f9ae8c097687c1d3c4eea6794825b45653504f987284e31"
    sha256 cellar: :any_skip_relocation, monterey:       "61a1ab51613a33005f9ae8c097687c1d3c4eea6794825b45653504f987284e31"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a1ab51613a33005f9ae8c097687c1d3c4eea6794825b45653504f987284e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1384d4c49fd10647b17d95dc22fd4f38358de2b5d1f7da5c20101cf94aabb0c7"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_predicate testpath/"clive.yml", :exist?

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
