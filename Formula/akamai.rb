class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.0.1.tar.gz"
  sha256 "f2b6fde649a66709856c2497a95142db752de75db11cf22ae54ec9ac4b768c8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a42e37ff7603ae510b4344dcd769a4b07695a1fe83b5b940ccee4fe828c6527f" => :high_sierra
    sha256 "2217fc60c4d6f9d22c29a2363e297db6de08a17de61c0016a85ddb597335ee83" => :sierra
    sha256 "e73f1a1a4f7d5c66d1ac727d7e2e7c5cc16878ad1bef74c2ab8277430589ada5" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "glide", "install"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
