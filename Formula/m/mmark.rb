class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.48.tar.gz"
  sha256 "8ab1295db3a9c1cdd353d4fc0f29daf1e6085b6e1989e30cd0348d0e17760bc1"
  license "BSD-2-Clause"
  head "https://github.com/mmarkdown/mmark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c128c58341499027ae9a6c557bc1deced75dc22784e3e66beb7721c9fc4b620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c128c58341499027ae9a6c557bc1deced75dc22784e3e66beb7721c9fc4b620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c128c58341499027ae9a6c557bc1deced75dc22784e3e66beb7721c9fc4b620"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0e8cc63b303aac12c3fc03b18ee44370ea84d973c7bd6e6d1b00cf6c4529590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "616c522bcc753ef42009639c7c9b7a0b90ef200aa7589abfc6b29aa7b755e4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16175f09d52d0e483ed0afc7d10be5859d2977cd261df2393d6830fa37511a62"
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
