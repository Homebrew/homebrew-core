class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "08a806e1f87e11e1a4953bf84a35c77afdd84a946b8e7c9b602443007eeb1fe3"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fa39efe766c9d50f88fc85a82d078c9216ee21d5f28f24d58a7e187c90c66a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff96cf444560152e2c5a90a0d580889ec1c1256954a1fd6a03ad9ca818208d81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9d4b23a37b41cfb94e5616d87fbb878b2be8754bf1e9bed04aa77c612ed65d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77084cc2b5c27891b05b568e12258703e13209a9553a02062ff0e69247a76755"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b4697c0f265b13e36ed026d5c31184c15b8c4f54bd17ca175857028dd9e0f60"
    sha256 cellar: :any_skip_relocation, ventura:        "b8fdc8af81be5c33da1ebd5a297fea16613529b6f75cf150a0ae8266d438f631"
    sha256 cellar: :any_skip_relocation, monterey:       "fa2632ba306d81e1aacc0656f85cb6a1906f721f937ddca49a3619eb9d37272d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af305493b55bce0144191768c62b9b47ff453ecc3661759de363947cc372b23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [CNAME] [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -no-color -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
