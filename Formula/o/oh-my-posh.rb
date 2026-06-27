class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.19.0.tar.gz"
  sha256 "6408cdf4df35760af89a1579b0145b597e82929d00acc8a143573861e49f0b09"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f9b483126d60935f5efe5d6818f28956f885d7478ea420f7468667f1ba2a4ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5c11d9c5e1cf347dcaf511dc787efbf808fcf30ac3fc605766e42100b312acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35aaaed703cda668a79cb038f5ccce35fb2dcdc85ead6175d72ca1f3e8c12beb"
    sha256 cellar: :any_skip_relocation, sonoma:        "01ee5f2e3a1a162fa40bb28bc1d48797ff4c7586db062e705d1ef67525c3623b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de6e2bea45024581f22c77d7d45fe4f0216c27e896377a42ff3a0b0720e11f62"
    sha256 cellar: :any,                 x86_64_linux:  "fcc17892158e1cc8a0f79dc28809c430cfc70a37e04e7134a73c62a94356a16f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
