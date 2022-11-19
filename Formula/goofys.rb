class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      tag:      "v0.24.0",
      revision: "45b8d78375af1b24604439d2e60c567654bcdf88"
  license "Apache-2.0"
  head "https://github.com/kahing/goofys.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53acc931a935c3e7c6230a59d492bf0cea7238167415083232d6ef37741b1cdc"
  end

  depends_on "go" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kahing/goofys").install buildpath.children

    cd "src/github.com/kahing/goofys" do
      system "go", "build", "-o", "goofys", "-ldflags", "-X main.Version=#{Utils.git_head}"
      bin.install "goofys"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"goofys", "--version"
  end
end
