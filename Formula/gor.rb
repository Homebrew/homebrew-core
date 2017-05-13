class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/goreplay.git",
      :tag => "v0.16.0.2",
      :revision => "74225ebb2236a46fd18a8fa4fa7de441497c13c4"
  head "https://github.com/buger/goreplay.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be3d38e72512a06ba10818963b72edd43a906a38c1cca1b6224bdbd0b8d2a971" => :sierra
    sha256 "52f1f8609a0d319c352bd758fa7c73a857ff9fe9f07a2fe25df3801d425fa607" => :el_capitan
    sha256 "160b2205ee416e6ac7a79fea27588eee268c3657f5d42eccc6e20410d963c01b" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/buger/goreplay").install buildpath.children
    cd "src/github.com/buger/goreplay" do
      system "go", "build", "-o", bin/"gor", "-ldflags", "-X main.VERSION=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
