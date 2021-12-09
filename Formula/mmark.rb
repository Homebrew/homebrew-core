class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.21.tar.gz"
  sha256 "c1219c7a5cf67947facd33283ccbabd4abb84cefca0741fd0188a65a2966ca3b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d77bb7f22d38c7463097c2f630c8b733ea41aea3027a214e7c1e3adf5f1c7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d77bb7f22d38c7463097c2f630c8b733ea41aea3027a214e7c1e3adf5f1c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "b68e13472b317a5dbbc60cc4f01ef309b6eff034c120c17a327400be1fc3055f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b68e13472b317a5dbbc60cc4f01ef309b6eff034c120c17a327400be1fc3055f"
    sha256 cellar: :any_skip_relocation, catalina:       "b68e13472b317a5dbbc60cc4f01ef309b6eff034c120c17a327400be1fc3055f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b307423f4d701220f720d0f34fcabf5b4e9fbec6f0eb76f410c05593565dd5a3"
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
