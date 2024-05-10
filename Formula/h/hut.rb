class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.5.0.tar.gz"
  sha256 "0f78917a2da718b0317cd73307549f429340c7f5cac84c6356341e4fae800cc1"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~emersion/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28deaf07b2c40db379d480d1bf234aa409c0236fed8d11d7b73b334e51ae6b42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67724bcf72d234f7c177845dc9171e12fb470ce96602a211eb21e1a74eb968f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0efb1a5a15a896cf1d71d8af25ad27256fe006a9f995f9fa9597a5f38c366a9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a112bd15f69981e649edaf3cab41deb90f3c49d67eee55b9d6907fa5928d450"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9fb102fb31737d97acb0a3da82951aad290da8d180f3cf31d09acd799a17dc"
    sha256 cellar: :any_skip_relocation, monterey:       "827d0cd88652496a00ed9e5fd35cc030c807b0c92bd6739a7731ff0748f44d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e3474db4e60f57c73fd2878f58ac06a2027a817151d5f48265ed4c9f79ff425"
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
