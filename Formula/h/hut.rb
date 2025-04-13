class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~xenrox/hut"
  url "https://git.sr.ht/~xenrox/hut/archive/v0.6.0.tar.gz"
  sha256 "f6abe54b433c30557c49aa41d351ec97ef24b4bee3f9dbc91e7db8f366592f99"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~xenrox/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b325236125aec42c74dbe8d208876f84960dc72b9315a5c259141f4aa361acfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a794a6301290cd276f54adb4563f0fc6d36a64df5c8e551d31c586130bd7f7d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dba5c5dcd21ff2ac28fd7cf85d0b42137475c854041a649f7ebf48526d43d58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5dffbec031ad1234fe4aaf50ca4dd01cebcb809f1c3a7ef6db808e785b2d09d"
    sha256 cellar: :any_skip_relocation, sonoma:         "76608f5475592bdc30274a0ae0a1d49653d3cd176916d668015e18dcb199703a"
    sha256 cellar: :any_skip_relocation, ventura:        "37d5b0b11aa4ec0d8e2d33597d75f3493ea447ed00c3dacb03f24153eebb6c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7fb7cd6dad34620815d931b1d559cb62b5557c47da05e3a37b5e90c6e343ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29634eb61ceaf3579e21f5eca143860c31d2938a33e60b6859df47bc43ba6040"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"config").write <<~EOS
      instance "sr.ht" {
          access-token "some_fake_access_token"
      }
    EOS
    assert_match "Authentication error: Invalid OAuth bearer token",
      shell_output("#{bin}/hut --config #{testpath}/config todo list 2>&1", 1)
  end
end
