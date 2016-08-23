class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.12.0.tar.gz"
  sha256 "79ebe866fae4e18767ce67446b8df51b44d58c209d68ad43a025ba9d9b8c2a3c"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ca13648127a5de34a7a993a686b33c5920ad55db2bd32a23a2508538300ab96" => :el_capitan
    sha256 "e465283fc80b97fb7f5ffc3270e7ad6987ce80d987ecefb982a8927d6ec9b540" => :yosemite
    sha256 "552a7b0c861c3a21cb4763ec911a3025dd24ee543c0f08433795b146963767fc" => :mavericks
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
