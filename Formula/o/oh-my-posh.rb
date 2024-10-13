class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.20.0.tar.gz"
  sha256 "e98d8d3b0dd9b75976c259099452c4cb02555e6b77b938f24b5597c7645509ca"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f59a2cbe272857ae055184247761e98dddeaf68976a373636b24c367c02e3c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "796586e2b99a990623750890f7168d5ad27dac356495ca5dbd566ccdb1c2505e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbc478387b664c9d766287aab1f27bc328924d700885119f27a83bd45b772a90"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f985801ad7018e928c0a298bc3ff03933c40b9ba6af6f6381db1f08f6dce9b3"
    sha256 cellar: :any_skip_relocation, ventura:       "4076db9de8d525aace722fe0b83101e444c8e534246326d10494cda78cf00f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0efa2f2e0cc84ac957c39be48f1a46ea6e34b2776b7304bd6f57ddcee82744b4"
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
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
