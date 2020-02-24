class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/goreplay.git",
      :tag      => "v1.0.0",
      :revision => "a8cfaa75812ac176b253ffe1d11eb9bbc7be7522"
  head "https://github.com/buger/goreplay.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73d9b114ff0abf11cd8f0dcde83df1c2db1921c1db8519060c9e5aec722e4b00" => :mojave
    sha256 "7ac5b35b06c5121f377b5c2e22f4c171dc245932eff1813b89af96a00eb4b42d" => :high_sierra
    sha256 "829149868a0fb7862c1ebb2d6db864e6e4730e3d7e138e638577aa8753334116" => :sierra
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
