class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.11.1.tar.gz"
  sha256 "3c4958d1ab9446e3d7b2dc280cd43b84c588d50eb692487bcda950d02b9acc4c"
  revision 1

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cebce9a6e81e7437bfd49ffd3b3f52a3c48f553b47799ef23e05484088e02c0" => :el_capitan
    sha256 "d506965814408a048221407f6887232c3f56b46ce26afc20f381c15980b514f3" => :yosemite
    sha256 "0d9df029068f96c13c5d64a4b5e0141f18e675c9b637e5f93a7a335194b4965f" => :mavericks
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
