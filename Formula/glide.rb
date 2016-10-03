class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.12.3.tar.gz"
  sha256 "a304c29267cf7e00b7299b6ac8da0317f2f4f4096acb6cf817d4c745e0dee8b4"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dedc72d451e5515a46d041695c1e002e65d1fc8ba9372c1390e228184239b3a0" => :sierra
    sha256 "4e4a8b3a959e8dff8c50c3a49483aeb7a6daa6de7b8b164c24348d626f6d4498" => :el_capitan
    sha256 "f62a55fbc7b3e5ce78d111e4843b9f958e3e31aa9e0decef80a725002e248e44" => :yosemite
    sha256 "3d4a9034e7d2c2eed872746f54c7f38ec8182258485b9fbe896e31b8599213af" => :mavericks
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
    assert_match version.to_s, shell_output("#{bin}/glide --version")
    system bin/"glide", "create", "--non-interactive", "--skip-import"
    assert File.exist?("glide.yaml")
  end
end
