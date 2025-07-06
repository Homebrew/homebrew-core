class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.14.0.tar.gz"
  sha256 "aefefdd41253310976fac8066a23018e19baef6ee4d8a0de96ae229d18258eb4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54923c71638dd98bce2dba842efcbbe2f80b768f8fbc1635c4f5deae04f46018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b10179399aa1d3ecc1cf46cbd9fa8d2faf24b226818005b52df14da7d68e28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "046d3eff1dd8709bc9eb0ca6053f2522fa13d8126ff6a831ebfd0e96ab5359e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e10031d659f73f5098814d75adc883856c6680c3601480f9a3d6b85bd05409"
    sha256 cellar: :any_skip_relocation, ventura:       "98bc02057ef21c1dfaaef658bbf67e8d5304e6fa9a169b23516eb2c18d05a91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b7b15e995b63b7e25b6eb1c00642148ee2367d58f906486d696d2ae472f64a"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
