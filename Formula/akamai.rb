class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.4.1.tar.gz"
  sha256 "a8b772aaa1f8721f7924ca031432c8dc81aeb8fb381eece8325412f0d6322312"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef0338487baa98b08d9fd325be71e0e74ce99a84a2088b56ecf0cee208a05656" => :high_sierra
    sha256 "7a7d07f6b0cbf113573b3c69e3db972a35a1ca7059bfe0f26e1af0a69cca2509" => :sierra
    sha256 "be42f42b7d297462b77412617a449ea9110773220e0a84ee387d277c2c81bdbd" => :el_capitan
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
