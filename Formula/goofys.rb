class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      tag:      "v0.24.0",
      revision: "45b8d78375af1b24604439d2e60c567654bcdf88"
  license "Apache-2.0"
  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da054592343f7423d91a3abadbe4d601295b1f74b3a404c36fdb4deb94f7019b" => :catalina
    sha256 "cee50248f9ac4d33ef8ca585ad94e3c9e6226fc464dfad86de2b7f9497b9f2b7" => :mojave
    sha256 "eb0a3cfe49104292c16d76dce71db34000b1a7214f660b3cff3a39e4b3ba7a44" => :high_sierra
  end

  depends_on "go" => :build

  on_macos do
    deprecate! date: "2020-11-10", because: "requires FUSE"
    depends_on :osxfuse
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/kahing/goofys").install contents

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/kahing/goofys" do
      system "go", "build", "-o", "goofys", "-ldflags", "-X main.Version=#{Utils.git_head}"
      bin.install "goofys"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goofys", "--version"
  end
end
