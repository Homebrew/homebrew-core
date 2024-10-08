class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.17.0.tar.gz"
  sha256 "4505ef84aa039ab701b9f639d33d8b0bdc7d29fcf1730b901498babec9919418"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7c0e6f2bf884c939144c65b6ac4925dd333b213e523bd89dee311bffc8101f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "653a944f1e4401776a6984cba218203ca01147906db1f4bd4a5c95245014d548"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "417ceff18a469336391d423e39be36086b822fc59fbf36edb8118f15c4bb63a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2262892802a8c8fa6ca76cdd6f28e1d5ab0ec432fa8824b5ff1027775766dc0f"
    sha256 cellar: :any_skip_relocation, ventura:       "37f33f35110c2b017b94ad549355d50837e982eff5ba187fd01f123d5e45e960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee85a4138570e8f34bcc22560e61bb72ef55fe46446f3b9d3f1846504b02507"
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
