class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.13.1.tar.gz"
  sha256 "84c4e365c9f76a3c8978018d34b4331b0c999332f628fc2064aa79a5a64ffc90"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2fd59c2fdefcbe51346603d33bf9ce19cf29e5b5719d8f556e18a6477ec93839" => :mojave
    sha256 "9fa42c78c7cd971eaddeec55597a33b05f3ce25eab526395fa686fa3f16ae3cd" => :high_sierra
    sha256 "ff5916390cf75b50291657e75c7c612bae81ad8ff23584d04abefa33990204cd" => :sierra
    sha256 "88825414624585386604980809adaf132fc18cdbe9c5b7cac1090844a4a01df1" => :el_capitan
  end

  depends_on "go"

  # Fix issue which shows up at runtime (when building calicoctl and
  # kubernetes-helm): https://github.com/Masterminds/glide/pull/990
  patch do
    url "https://github.com/Masterminds/glide/pull/990.patch?full_index=1"
    sha256 "f3711026b3261b62ca67fbf737ccae6889922f50d7fa25ba9b9a025b6bafdb6b"
  end

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
