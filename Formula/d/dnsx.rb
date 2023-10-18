class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.5.tar.gz"
  sha256 "e55aff16ff72d7408108fd754c7d67baa6936792fba87a362f12c6871bf26ad4"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ae2858bbd9627cf9f2a653a457327fcef117170eb433669820a44336c0f6420"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a64217d06cdeba903b2b362d0e2de0f22ce19a797d38736df06c49c4ccb86bb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d7ca87b6b3052d08ee19c18cd625b5afb009344ba94023b1423e1ae26464d0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "addb094b6ee28822fcb8b16fea8d6ce9a3ac36891d9013beeee17e3b88db664e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2809e94284a3dc58fa9dd15cc54e4e27769b04d3be917b9bc4b3c89421d0ef8f"
    sha256 cellar: :any_skip_relocation, ventura:        "afd205b9da91a63184540b6f8c5e8cda405b8c699861bf481380f81dc2c4063e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac22abda2803954d5dbd554060b673083ebd21b07201e4866036b05a8988bbe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc179d4cc7d5d44e0d1d1706b4ab4288fba90fcbd32cd1668c2711e7ab44c640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7785ac663c7d3ad1410fd8061920135f8355cbf416477bdc9672a3f33de5a837"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
