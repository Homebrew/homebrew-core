class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "8d6a2641db7c3096fd22cbe84f74439dd9bffae364acc61fbfd51ab143976ed2"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "098bfca6ba2ffbc4abd568e15835a704f520736e98f697f3ab1c8ba995adc36f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f6b0ea8e21bdb79286f28d39d6103a37c03d8805ff55f0ef97d6cb9c085ff3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a786292ec90aaaba118f12543c1dbc0f4fe39431e498da68e5a5f365f65b60fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef6ebe890d9011395ca6b308db1a60073199c1d15e5b93cd2fa419337fb227ca"
    sha256 cellar: :any_skip_relocation, ventura:        "4363ecca27dcb2fe72f7106e52928ab1f0ab5ab2697b507a397dcb4a5d17ad43"
    sha256 cellar: :any_skip_relocation, monterey:       "c35adc313a46ac80462c1f6234b7d2ec45c7fb111b3cf69a0c6cca319577d6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "476e51fcab787f26cc51abbff5405136fe91ea95d009aec01e2b06db3df11d56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
