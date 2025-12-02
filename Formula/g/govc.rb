class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "3a68190d70d2f39b391a2f9122095890373baaaada091f243a86ca0ed0b482a0"
  license "Apache-2.0"
  head "https://github.com/vmware/govmomi.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da24d2e70e213e4971dbcf66e49ea74c1e356c9cd0790b844e75a9e2696f2946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a2b435e3f5ba3e109b43040eadfc93ac527d47d110cea5b6d16cf90fee5c486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a2b435e3f5ba3e109b43040eadfc93ac527d47d110cea5b6d16cf90fee5c486"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a2b435e3f5ba3e109b43040eadfc93ac527d47d110cea5b6d16cf90fee5c486"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8e157a51db5f7755f79900d37a21ca6f0ce39baa2444beb4c1dcf5d26bb20d6"
    sha256 cellar: :any_skip_relocation, ventura:       "a8e157a51db5f7755f79900d37a21ca6f0ce39baa2444beb4c1dcf5d26bb20d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "658d3cfe422d11f27d50164637789ccd772e94f9a0aeeae4736905ba9b498632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1b4d201161aec17eb610a9b0749245185f3043d0406e270af1748f40f4ff441"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware/govmomi/cli/flags.BuildVersion=#{version}
      -X github.com/vmware/govmomi/cli/flags.BuildCommit=#{tap.user}
      -X github.com/vmware/govmomi/cli/flags.BuildDate=#{time.iso8601}
    ]
    cd "govc" do
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/govc version")
    assert_match "GOVC_URL=foo", shell_output("#{bin}/govc env -u=foo")
  end
end
