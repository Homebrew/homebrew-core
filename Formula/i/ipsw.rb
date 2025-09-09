class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.625.tar.gz"
  sha256 "b8c012650eeb359fc0453d344cbe99b30a62c1a1dbebf27c06f365120f0b6dca"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e63743dba9d009ca1a45d7b379f3cb4745cec5292a4acbe889da8edf5814c189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a88a8c374ca6d7dc8268a89c44891cdaf0cc6f095228843529a8e4893838386"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f81fb8560f9c6bf8f691c2434c05b9904ba04f20c7c85be10ce67a0269aaa5dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "12c5dfa012eeaa4419c2bbc02894231a876feff3e33085fea15bf2024d648992"
    sha256 cellar: :any_skip_relocation, ventura:       "12f31168eea5a7cb9152115f1a0dd70ecc61a4d9d30d564e4e9d8a82dac2cef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99bfadf6d94b4f2a47e82eff1c8971ec4bfb3eb713c853d0c85440782b69ef8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57563fa37061035a07d5311fbf65eb2bb3d83eb7187cc2e1881ea257477e9367"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
