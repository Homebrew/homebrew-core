class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "0912050b3be3760804afaf7ecd6b42bfe79e7160066587fbc0afa5324b03fb48"
  license "MIT"
  head "https://github.com/simeji/jid.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dd788b2fba27931b86f826dc8fb3ff5f2e021df22864ec4b453a86bd640cbcd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "285b46fb790b33b8516dbd0a7053fa76e64b54a04006f50c74b1539dca991cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9835df7952c4170d1bfd899026e1cace590dce8abaa64b01f8784760533ae5d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aa9387c65b9577a1e7d6fa2a73e9da8102809d2275fa1d97db02c0ed6622bc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af3284fbdac510d46260cd52b4b1db36cb2baa71f02ee68758bea6be4af5ffb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37f25dc38d57a971fb609224c33802bfa4213b58d825b188a67eb653af1c9e2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c50129673b66bb9cee8ce889ea95082e1d479e605ce7a99c18c522c2b54150a5"
    sha256 cellar: :any_skip_relocation, ventura:        "0966f7f8749c7aa40838d6658054292523d414aa2edf01d9483c35092fac2d23"
    sha256 cellar: :any_skip_relocation, monterey:       "ad33b70ab6cbfb324c1842d3b1294beb011b04c85086e9c8aa4fdfbe1c6aedc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "703bee89d514891dec82186680f2ee9837b1599721c3d68405fd4c72d015a811"
    sha256 cellar: :any_skip_relocation, catalina:       "0b45fe9c59facbc6b2bbacf4b52927934b09d6e2050ad3a5b5a32434a4bd4751"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "440c0003187faeac72ff82a00fd05eb4de6cc849d82a21e1a07c30b319320abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2d04634a851f7ad8d10869571b6820cd31da2ef068a5c7fd6b03f512f5dc4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/jid/jid.go"
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
