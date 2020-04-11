class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag      => "v0.24.0",
      :revision => "45b8d78375af1b24604439d2e60c567654bcdf88"
  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f61fc7d7e7ce1edf63fce85629a01884084db6274274800a79d9dc5006f593f" => :catalina
    sha256 "654aef18dc52f479fb33d75096f039b50804a3c61e397326a2bfc3fa71d51b35" => :mojave
    sha256 "8097c11f0f0b20db1280b2b8616b4de87d9f21d76db2e0ed1c99b8b0db2491cb" => :high_sierra
  end

  depends_on "go" => :build
  depends_on :osxfuse

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/kahing/goofys").install contents

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/kahing/goofys" do
      commit = Utils.popen_read("git rev-parse HEAD").chomp
      system "go", "build", "-o", "goofys", "-ldflags",
             "-X main.Version=#{commit}"
      bin.install "goofys"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goofys", "--version"
  end
end
