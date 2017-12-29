class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/v0.0.4.tar.gz"
  sha256 "68d244558ef62cf1da2b87927a0a2fbf907247cdd770fc8c84bf72057195a6cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf13908c9c79f7cac0edc461349172430f3e2da5f8795ef4485cc59ba4bc5e0" => :high_sierra
    sha256 "46a84a4885f8d8af04273911c16aa4a7d2a39390eb116257e9868ba30e1b9562" => :sierra
    sha256 "2f8c0c979d0f9adf7bb99b3fe84136af6c261445544f23fe7ed12d543a0e5485" => :el_capitan
    sha256 "8ee7e6511ddfbcf8f5f7edc6f42bbbe6662e20e9ee029f7f2d13bb66e9fbf9e8" => :yosemite
    sha256 "16d1efcf64c807f2db0a270fcff9b973eaf54c280af2819615fdaa46ff6cabc8" => :mavericks
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prydonius/karn").install buildpath.children

    cd "src/github.com/prydonius/karn" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"karn", "./cmd/karn/karn.go"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/".karn.yml").write <<~EOS
      ---
      #{testpath}:
        name: Homebrew Test
        email: test@brew.sh
    EOS
    system "git", "init"
    system "git", "config", "--global", "user.name", "Test"
    system "git", "config", "--global", "user.email", "test@test.com"
    system "#{bin}/karn", "update"
  end
end
