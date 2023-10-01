class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.36.tar.gz"
  sha256 "e4960500a7092767a9424fc8f2c04f9f2604f85570503002b527303e207f06f0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202bb55974eb8381942abfa8f9a66a998752e20dfddf810e966a31529043801d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "202bb55974eb8381942abfa8f9a66a998752e20dfddf810e966a31529043801d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "202bb55974eb8381942abfa8f9a66a998752e20dfddf810e966a31529043801d"
    sha256 cellar: :any_skip_relocation, ventura:        "1a1df3aabae071720eeff492dd495a52886130c10e05c7eda7a549e7a10f9db7"
    sha256 cellar: :any_skip_relocation, monterey:       "1a1df3aabae071720eeff492dd495a52886130c10e05c7eda7a549e7a10f9db7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a1df3aabae071720eeff492dd495a52886130c10e05c7eda7a549e7a10f9db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "093b6bc89bb9390e5982d0743eeb176876593b262e0a449b5e6115067526d2bc"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
