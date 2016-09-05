class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.12.1.tar.gz"
  sha256 "103909ce7f7ba95c9fa3ea03fa9a77393ab50a069c71608f0bc92aea35e7a15e"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c39f27dc19b78cc68a8846a79f3d19853ccdbb45cbcd9ae0dd4f09af5e2353f0" => :el_capitan
    sha256 "ab18aa3db50d41073bb8f4e3c0f56bcf19f99ce207a61ca96dda2fc35783778c" => :yosemite
    sha256 "ab208a4020598c5b0f1290337d00ff7681d14e6427176d9dd9ff8e0d9bdd06a7" => :mavericks
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
