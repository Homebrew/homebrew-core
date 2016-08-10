require "language/go"

class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/gor.git",
    :tag => "v0.15.0",
    :revision => "ecd7e3a5e508886afd15ed670d72aac5dde9e370"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09bc8e6d7411acf4938005f0d53ab4ebbb8b7e334d03c8bc722bf392a236cf85" => :el_capitan
    sha256 "3c790b1f23a5977c1d03a47df86e3c5bf906882283122fe3ae7fabb3d24c8406" => :yosemite
    sha256 "a5513e92344941dcc5d683dc56b7e37897df1c4729007d38f988cfeb690fd615" => :mavericks
  end

  depends_on "go" => :build
  go_resource "github.com/google/gopacket" do
    url "https://github.com/google/gopacket.git",
      :revision => "b1af1fa2fcae43d2eef926f31c7acb1c93c6e24f"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/buger/gor").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/buger/gor" do
      system "go", "build", "-o", bin/"gor", "-ldflags", "-X main.VERSION=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
