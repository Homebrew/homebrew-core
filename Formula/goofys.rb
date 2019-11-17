class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag      => "v0.23.1",
      :revision => "b720aae5b4845855bb3d06b8ade10585934cd1e2"
  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94c0635881cfa11f9df09d946262c29dd0dbd255ce04448385173f127d8c699f" => :catalina
    sha256 "31f7241e733feb57452a13b3909fbfb144f2b32a0c3938dbd33d1537322dae88" => :mojave
    sha256 "a8a27367dabf549fb4f80324dfbbe266e79c7cf3693d639ed25c04fc857f0968" => :high_sierra
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
