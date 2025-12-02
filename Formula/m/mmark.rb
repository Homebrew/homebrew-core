class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.47.tar.gz"
  sha256 "131d618c98050fc2991147a0c4d653b33d88e26a0ef888701c1432fd3c7fd1b8"
  license "BSD-2-Clause"
  head "https://github.com/mmarkdown/mmark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ff8877d9dd40b4ed6501373636d635595b1f5007ad7070c8329b0b5eb064184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c947b781f68435614d54d3d32ffeafb54652799a7dfe229aeceeac09a15c9de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c947b781f68435614d54d3d32ffeafb54652799a7dfe229aeceeac09a15c9de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c947b781f68435614d54d3d32ffeafb54652799a7dfe229aeceeac09a15c9de"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b039d7b657a3e6bcb00d81465cdcbde5e7471ec7950456a36ae82165f04298a"
    sha256 cellar: :any_skip_relocation, ventura:       "9b039d7b657a3e6bcb00d81465cdcbde5e7471ec7950456a36ae82165f04298a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0615d43d7a64562f8a668ba7c9c5b1299ab88876752a180a27be6626e7b22519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06cd28834b3543f829eaa8952a1930debba626ee0664757a8ca2fd53d08975a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
      sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
    end

    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
