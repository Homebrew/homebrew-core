class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.5.0.tar.gz"
  sha256 "c8a78c9c84c5796936028e3487cbd7bfa256fee505eae07e813d32e02fa2a09f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ab996f37fe986c7e797437a8db12fb5aa68ca1d8a8db1e0b2fe89a98c1a002d" => :high_sierra
    sha256 "4b8a756c5004a74c42568b9d96c3b68aee7195b8b6377858adc871acd1dcc2b2" => :sierra
    sha256 "64293d9ecf63fa5858c0a353b1e798514fbf20d5ca64b8ea3d3c922819e4ef0b" => :el_capitan
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
