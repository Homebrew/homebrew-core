class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.12.tar.gz"
  sha256 "edd03f4acf50beb03a663804e4da8b9d13805d471245c47c1b71f24c125cb9a2"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5b8320c45af0fd83e8ce937ec25d697e796e7fc89a4fddc9c0c5b1aff57da72" => :mojave
    sha256 "a747baee9d6fdb09d9593a9afcb3a5dc0ed5a6a2d34eda0d4dded49cc4da6895" => :high_sierra
    sha256 "387f1854614fc77af4321aab808a09df3c978a1364a233cdc0ff57c0d25485e1" => :sierra
    sha256 "6f5b6d0c3a5b05a876f278b73c44efcaccb2b02a2b2f23ca4936992fd22555f2" => :el_capitan
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
