class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.13.0.tar.gz"
  sha256 "ebbfa28e547db921add3557317c810f87d4ece983213d8e9899783b3e3b43ae7"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5bdbe4484a8690a81791e188f913a2f70b622623380b6db049619c1539f494d" => :high_sierra
    sha256 "a8e2fb3f3e6c68d05d12342a53ee6f3c8d666262d484064c26888a92e420f20a" => :sierra
    sha256 "01076083721c1d1f5e4fd9f3d8e6dd88472a707e306e32670dc02fb3249e8016" => :el_capitan
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
