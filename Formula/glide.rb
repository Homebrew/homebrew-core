class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.11.1.tar.gz"
  sha256 "3c4958d1ab9446e3d7b2dc280cd43b84c588d50eb692487bcda950d02b9acc4c"
  revision 1

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "270ba9b495ba14409fab440b4cc45c9ae4793ad2fa77e59c7f838dc9a0f34700" => :el_capitan
    sha256 "de848bffe9a1f512a7a9c067ef13309c01e6bb9ee2a8f40ea888547613ac8cc9" => :yosemite
    sha256 "7e393a090ea6dc107fde98fd3d1e6da914269589efbaae3c26fbfb20ff2d50eb" => :mavericks
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    glidepath = buildpath/"src/github.com/Masterminds/glide"
    glidepath.install buildpath.children

    cd glidepath do
      system "go", "build", "-o", "glide", "-ldflags", "-X main.version=#{version}"
      bin.install "glide"
      prefix.install_metafiles
    end
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match version.to_s, version
    system bin/"glide", "create", "--non-interactive", "--skip-import"
    assert File.exist?("glide.yaml")
  end
end
