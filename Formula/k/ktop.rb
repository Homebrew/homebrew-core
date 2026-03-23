class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://github.com/vladimirvivien/ktop"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "f255733a56ce292cdf6ca543cf5ef85969814de8ccf60431d70b85dfe38f720f"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5cb8ea39afa823108619ccd20c35d86121c5a3e7cf02d368a9fb28cd1e4b21c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c84e3f69f42af91645d317fe073db0d79bfa678afc96d9b73b94e62dd70e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4f2abf9e19563771d903c3fbda6e8920f9948c914a59ced575594f340dd8ea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "33107e3156c832d1306a9f10363ff6f88ebc9b75e7d8811cb80c35a596074f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "353cead1dca60cc99e4cfe75ca7121b7a889748b8333d28910e8abf0201bb4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a601cb39d5c9b5625d6e444a73886ca58ad180d764a95ba4ad18a0dc739ba52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
