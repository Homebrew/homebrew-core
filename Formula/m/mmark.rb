class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.43.tar.gz"
  sha256 "9f672c36a65dd8013f416ab8e7f85b0143cf7e92af6ba3f965163cffc5299262"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1691c4e18037d68503a15db9deebdfc46c96a3614491be9600edf8fbba00078a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1691c4e18037d68503a15db9deebdfc46c96a3614491be9600edf8fbba00078a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1691c4e18037d68503a15db9deebdfc46c96a3614491be9600edf8fbba00078a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8dfb8f8f5a5ef67bf931bcc2c122ab7275e7145da348df8acb0e38c93477f64"
    sha256 cellar: :any_skip_relocation, ventura:        "a8dfb8f8f5a5ef67bf931bcc2c122ab7275e7145da348df8acb0e38c93477f64"
    sha256 cellar: :any_skip_relocation, monterey:       "a8dfb8f8f5a5ef67bf931bcc2c122ab7275e7145da348df8acb0e38c93477f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f41fd0f96801cfe4bf957eb19ed7446f609900bf347665e2084ae4352bd3f223"
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
