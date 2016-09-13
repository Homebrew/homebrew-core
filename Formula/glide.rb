class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.12.2.tar.gz"
  sha256 "ebb20c81df87e4d230027e07d81d88ce8ef18400df62c82f7b766693acb3106e"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "841f11fd05865086f2318732d92ad0f77e94cbc19175abeb86635007b3cbe512" => :sierra
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
