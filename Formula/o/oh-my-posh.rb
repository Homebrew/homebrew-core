class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.20.2.tar.gz"
  sha256 "b21a95f5f8659733761cf2088a19b34e253d231d77efbfc9aea4b29aee208113"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27983cc88bfbbe4535a7ebdbc3b777dcb7c18b976f6f987cc511d97241ae66fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eace7bea841075aea33704577907b6d13f3a388f97ce5ecd033348de0090fd90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e25896dcac6ae5a958e93471148a87f4e042016e9c42e2640936ad6f653bf104"
    sha256 cellar: :any_skip_relocation, sonoma:        "700bb6e2c83db17928c3b4063baaf7adfe7ba97a1765d66b7b3d40ad1a98f9dd"
    sha256 cellar: :any_skip_relocation, ventura:       "c0f1320a6edc0bde25e8ae54f1fdfffb820c48308251349e572cacdc5e8d24a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309c5abced633b3eb0be1b48ad3658707b818d8087d0b2083f8b101572c5a73c"
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
