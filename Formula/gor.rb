class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/gor.git",
    :tag => "v0.15.1",
    :revision => "967c380dc3ca1a96c6cbabd6296b0656a6546016"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc9f2415ded76b790d9f27579b71a6d6af7570c49b3c74dd1451a494c0857057" => :el_capitan
    sha256 "9c726a81aefa712a33e3a344761672ebad2d7d51f5ee31a40d95c3f1d1f91ed6" => :yosemite
    sha256 "2c323e895d563fe8c3663ae7ad3e78d6526727917da921b1b0454529c00a3f74" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/buger/gor").install buildpath.children
    cd "src/github.com/buger/gor" do
      system "go", "build", "-o", bin/"gor", "-ldflags", "-X main.VERSION=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
