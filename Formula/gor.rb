class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/gor.git",
    :tag => "v0.15.1",
    :revision => "967c380dc3ca1a96c6cbabd6296b0656a6546016"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91081c290396a2d8d52fa9f76b075af47764df3774f3a1d9a8cebdb111f0b665" => :sierra
    sha256 "664cff81e41321a473a087aa0ca465fa8df7ddc6844c468c3445fe9fb76cb6e5" => :el_capitan
    sha256 "07bfff5c49bdcd69bc145369d306a7b538b58586b4d6347639b92531b3074644" => :yosemite
    sha256 "aebc9f938167cc563d674b7acaf0110cb359d854fb98689135ae9fd09be0648d" => :mavericks
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
