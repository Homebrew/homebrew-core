require "language/go"

class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.3.2.tar.gz"
  sha256 "aac1e592d694996f1ff86e68245cd6e470a82ffafb3bd472f76523860023ac80"

  bottle do
    cellar :any_skip_relocation
    sha256 "57b015e52ac0dee9f7a9e6a68102dd15a305ebad3dc1e7878489c1a7a23d9ffb" => :el_capitan
    sha256 "2940e510fc263eff5c4477df44f8b4fa9442baef8b55e3655594453de488c912" => :yosemite
    sha256 "bba05725a4c3386fbcd5e950f6fef888537f7ea59588fbbb32e7d2cd552b7ad6" => :mavericks
  end

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "c197bcf24cde29d3f73c7b4ac6fd41f4384e8af6"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JFrogDev/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/JFrogDev/jfrog-cli-go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/jfrog", "github.com/jfrogdev/jfrog-cli-go/jfrog"
  end

  test do
    assert_equal "jfrog version #{version}", shell_output("#{bin}/jfrog -v").chomp
  end
end
