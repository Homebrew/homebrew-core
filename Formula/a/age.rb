class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/v1.1.1.tar.gz"
  sha256 "f1f3dbade631976701cd295aa89308681318d73118f5673cced13f127a91178c"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8c3818aeeb7eea70eb6b5bc3ea0cce27362a859b198fb74a00db98c6580785b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac5bba583073cc0b27cfc6d4429ba0f35b0f19713db12c053fefd81f37596024"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54ea15cf68dcc78e96564825785b348d4f84c76042742b1ddf3cb3db2eb3c0fc"
    sha256 cellar: :any_skip_relocation, ventura:        "93bbcd6f694b2cc9a35ade57d2a9b39059bc6afd27528bd3dacd01bebd901ef9"
    sha256 cellar: :any_skip_relocation, monterey:       "8f7a53819cbc634ab0f496ef6d8b2ae9cf9ceacabfd2e195c3277c5161aedcfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdfdb069c08d9c8062bd1f6b951000ee9fdcd8fe57e50a4e522ee508931569df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "035ffde6b73ec870c742ed42b4fb4a0709ba1fc9394fee63b2689a2d0c9d84d8"
  end

  depends_on "go" => :build

  def install
    bin.mkpath
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "-o", bin, "filippo.io/age/cmd/..."
    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test")
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
