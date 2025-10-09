class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.22.3.tar.gz"
  sha256 "fa50fe01b6137422c364e24f379766e6d7a3805108addf6d60580040b0ceb985"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01795b437735623e2c7efaf72e6b5dc5b9ce925777c978d0fd0926cbcb0f18d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411a19b64798710899aca59c4609e63fea4a962edb9ccfa5f55181a6e7c55ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "507c9191307672330cbe0aca8cb86afcb2c63000b8b82e4502d2a50a8bb613b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff90579753d3166008178491926ffe7af7b7080dd9e8caf435a395a9c20f8fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4f3105394a4b752d2787baaccc06038c0a4d8ebeffdb2bbaa3309811d79778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8b71ce146f5f7d605868459083a46ea85400030da61ad50e87b73ecb3f512a6"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
