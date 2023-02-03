class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  stable do
    url "https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.5.tar.gz"
    sha256 "7ba1340ce46566ca8fa1565ef261519dee5b1c7007aea97eb1f9329f8a3f0403"

    # patch for quic-go, remove when it is available
    patch do
      url "https://github.com/mr-karan/doggo/commit/7db5c2144fa4a3f18afe1c724b9367b03f84aed7.patch?full_index=1"
      sha256 "e34f71e6618817edfd0d7b01657a407e9573e74a7ea89d048abc95bac46bb21e"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b52a39277350522f9bf6e5d466942c488b4ff28451470a4514163f1f0c1c621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9efde0974a3c99bc20547bb46a859e1bc16e7a9fe51258203901ae527f2e9f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fa71c6ad80aa231c5a8ccac33dee9c37a9d83c18f144cfb48d3effab814ff3c"
    sha256 cellar: :any_skip_relocation, ventura:        "fa45db6b6ca4c7923fdef34b82aa54444ecfc6277379a4e5c1bebff788cf5dee"
    sha256 cellar: :any_skip_relocation, monterey:       "14c0702c87d0245c5d5ad8b238bad6325ed1c580a4819e838f42e85caf74b439"
    sha256 cellar: :any_skip_relocation, big_sur:        "c57cdbc88339c9d7291ca80b7f066693303dfee95959cf138f33633a0a68a51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc720679ba537b8b881624652d13b1753a5f59b78dfb91930214e7b50f3b6e46"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildVersion=#{version}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doggo"

    zsh_completion.install "completions/doggo.zsh" => "_doggo"
    fish_completion.install "completions/doggo.fish"
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
