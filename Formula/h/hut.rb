class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~xenrox/hut"
  url "https://git.sr.ht/~xenrox/hut/archive/v0.7.0.tar.gz"
  sha256 "5975f940740dd816057ab3cf20cebde3ece3250891952a566f8555f73fb67b21"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~xenrox/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2db4db62d5fdc914d509199498e59355e5b4525fa9ece439ab8fa29fb560873e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0accee6f54039fe7bf2320633dc848345253b6be579fcb47dc2cc816e437c8d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f75e366c90393fe0c599be6e75281b403be956864e308701b201201bf3bb9ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beae4d947bcf81b3a9a15dd1e5f6b866819d988978b83cae1e2ecf769b9c086f"
    sha256 cellar: :any_skip_relocation, sonoma:        "407c921c2225c840a8dea33ec53432a55af8eb30e96a0543369612208adf7a08"
    sha256 cellar: :any_skip_relocation, ventura:       "3258041942028708cd5291814b0dc8abe3651ecd08b8044af5b29614a9fc689c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96de45846fe7552f4b4bdb212d17d4032c0bcf80b2a8552ece20aea9bd1ee21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "703718aaab915baab3c98e02386f865619ea9057f4c966993d408d4256ab5ee7"
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
