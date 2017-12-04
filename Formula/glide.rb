class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.13.1.tar.gz"
  sha256 "84c4e365c9f76a3c8978018d34b4331b0c999332f628fc2064aa79a5a64ffc90"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "caf9796752ea6c302aad5ccb6d2d415961e338743ad93a849c012654f1826057" => :high_sierra
    sha256 "31aa6f3b39c0a101dd94e9dda1a7d76fa6d22d8865effa0e96ae5d61d799233e" => :sierra
    sha256 "9a400081061df8e2cbd82463b763e20e2029df47f750a8622ba6e3e81f21fa66" => :el_capitan
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
    assert_predicate testpath/"glide.yaml", :exist?
  end
end
