class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v4.2.0.tar.gz"
  sha256 "552d94e2a0e5b3b93f8659f0a9ed5bdae4622c46a2418ca2a40573862fc991dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dd2e53eecdaa34b50562b657a445b4db885b960ebfd3dae9fcbcf995ae6173b" => :catalina
    sha256 "bd9e7f0f71fc030cb850f9e79f08c7ea371b0e22b129c6e2d566345a12528cb2" => :mojave
    sha256 "26e2787989cbfb1c795884d0c3ccc855442c1362aa242e2d4f91bc9b5393c1f5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/antibody/antibody"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags", "-X main.version=#{version}"
      bin.install "antibody"
    end
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
