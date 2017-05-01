class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/goreplay.git",
      :tag => "v0.16.0.2",
      :revision => "74225ebb2236a46fd18a8fa4fa7de441497c13c4"
  head "https://github.com/buger/goreplay.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fa32bb6e184223689e8c2eaa1c3fd0573d30ae333ca1b6bbb6f201707c0dd29" => :sierra
    sha256 "31c083b7ffa8f7d05cffa306e91e74199f6229fb18d50db08102ff5f82b96918" => :el_capitan
    sha256 "3aeba72c9bf9853869bef28047dfc9ea75f3c676b3c5c5f1b0f21551fd536569" => :yosemite
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
