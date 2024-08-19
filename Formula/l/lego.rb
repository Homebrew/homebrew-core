class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.17.4.tar.gz"
  sha256 "27f873708c904ce6c6347f47cae1eba3a00a7948e2b915982f8a209f069c1277"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c04b1dd9e57859157db1226957d9cec85944b1804fb1b7f6233225b30832359a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c164df873603b8818de77a86a45878ee7872a724d60acf1d5b700ee49027882c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a6a7d6ba7082aae0c5c97593318c2326ac917ab32be70656fc7911b7cf26b86"
    sha256 cellar: :any_skip_relocation, sonoma:         "724859b8eda97dfb8cf4b2acf561a6e918d681f67f41231480b047e14cd64b13"
    sha256 cellar: :any_skip_relocation, ventura:        "e031b684d3c701a810f3cbdcac6faa673f8a17be478a59b000616598f423df61"
    sha256 cellar: :any_skip_relocation, monterey:       "dfd089961abbf5207ff031a108a03f27b9753c5d4594b2166ec6639041f7b8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff363cddfc732bbf38bc1c7f393eb4ce0bba58aea70695f7997963edfc58baf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
