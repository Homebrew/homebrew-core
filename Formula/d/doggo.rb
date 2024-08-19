class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "d7b8c742680332b172ad64e4d625449537c89e2607b7d7fd83a34fdd737c039f"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb99148c795246b24c22c45416117585416ac4813212087421bd3d18cc83f8e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "260a08b5b69cfc07ba076cfac18c62c2588eee46fd24300f0582a8523dbeb099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41758c624a2d7bbe64a6c29b9dbe99338b79518bbccb324ef5340b5360831a91"
    sha256 cellar: :any_skip_relocation, sonoma:         "9224597dc0ed6373b4414cb0380fb305d72ad4e21c2f83208cbb27d47aedf16e"
    sha256 cellar: :any_skip_relocation, ventura:        "fae9a2769cf764ab1aefd338bd874f9765062ee57b93326d5ce63b2bd770d908"
    sha256 cellar: :any_skip_relocation, monterey:       "82c4f14f87a87870d9c038c276999e0c7d996f0b5de2dc3c0431da06e6ef142b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3056defe4f4ce81c2bda693cd8078f2e1b5fd00ca6fe30462bb8bb159625b459"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
