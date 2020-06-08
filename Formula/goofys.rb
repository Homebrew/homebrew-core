class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag      => "v0.24.0",
      :revision => "45b8d78375af1b24604439d2e60c567654bcdf88"
  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b7ebc820dd0ee1cb37195baf2c6b7774c22e4dac29f7ec049a025400c4b0f35" => :catalina
    sha256 "fc40b7665dc7f0f7c1c990995027913bdac95d12255e8ed25183e42eee14c966" => :mojave
    sha256 "0ca4cbb28a7dc528cc58f0d64ea4bb64d732d83448f4db6b3dfa9d1ade6ac100" => :high_sierra
  end

  depends_on "go" => :build
  depends_on :osxfuse

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/kahing/goofys").install contents

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/kahing/goofys" do
      commit = Utils.safe_popen_read("git rev-parse HEAD").chomp
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
