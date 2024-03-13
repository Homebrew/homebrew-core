class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.16.1.tar.gz"
  sha256 "e57ac5d43f459f9f0c2b101561c442f88895023bfff5dbd7a8750d632e7a31e6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4e01b62eedfa6a9a2e987d18eade56db5b629464b5d4efab102a1ef57724ed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "623df2fff2d694a14b432f600c2ffca46ed329de245443231b314ec00ec00386"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bc03ea92be223267d583f981ef9117554f86ff88aa039ad0b6006dde854c59d"
    sha256 cellar: :any_skip_relocation, sonoma:         "57881f90558639bd86671bdd7a0b014915dd69c86acc89820b3fcaf0992a1656"
    sha256 cellar: :any_skip_relocation, ventura:        "c314b255688cd6a434acda991a4b89050b31e980777f0b253d13f9c32c59848b"
    sha256 cellar: :any_skip_relocation, monterey:       "dc62dfc64d1e124ec72a7a4b1009cd3b340df570a47ad45e7cfb20e5818ebaf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819312cc3caba82b05e21910c8ce711f9d99806e6cdef8102020a19ed4d7361e"
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
