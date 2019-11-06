class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.12.tar.gz"
  sha256 "edd03f4acf50beb03a663804e4da8b9d13805d471245c47c1b71f24c125cb9a2"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "481e7d245074b9bdfa76254df634392e6c1473c4d8b2325f75689940d76c09ea" => :catalina
    sha256 "6696ede0ecdd827b0c2e16fc0b728049741f49eb804a65159d940cdc5c536ac5" => :mojave
    sha256 "d05b6eb72c80e1f30e0cccd529d60ae8521abdbaeea3b4aa3a7e75eedac8a9ff" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-ldflags",
             "-X github.com/elves/elvish/buildinfo.Version=#{version}", "-o",
             bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
