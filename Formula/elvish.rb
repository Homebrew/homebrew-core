class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.13.1.tar.gz"
  sha256 "83275a4c36f66b831ba4864d1f5ffdc823616ed0a8e41b2a9a3e9fcba9279e27"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aba852bad9771ad72205d9413f8757fc35e80c00ba6e1a85762a4df7a6a266fb" => :catalina
    sha256 "cc191e51b72846bab901f86e9cf2bc53b30f236b8ec3caeddbe47ecf59b3d719" => :mojave
    sha256 "c97482bbd26a3f0daadea9a9e87d1370d8f3e3712bd6361bcf217fa020da9a47" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-ldflags",
             "-X github.com/elves/elvish/pkg/buildinfo.Version=#{version}",
             "-o", bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
