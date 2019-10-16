class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.29.2.tar.gz"
  sha256 "48338ec9c7a4c85a5b8d77252ca745dc0561bed20f4e3b7f71532f41e45667be"

  bottle do
    cellar :any_skip_relocation
    sha256 "48dbf129e68db5a3a42483a8b72a8fffeba3d7a7c2f7f32e7e7462e89d00e26d" => :catalina
    sha256 "950734c8a789ff9095c1e243b68601579fd3554d64f892e4dfd6d16a38a3049f" => :mojave
    sha256 "e51cbb443610d1e30bab0834c5deb1c324e36eea6864ee127c007d21e73c58c3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
