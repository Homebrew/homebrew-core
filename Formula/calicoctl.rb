class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag => "v2.0.1",
      :revision => "5fa93655169003652350321d90410ae4dc803d32"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d665e33cacc7a040d918b3cb78c059bdc8ca407b186ce9f8b328fe2319d809f" => :high_sierra
    sha256 "be7c186b2e26b909e9adf0defd7db6ff1b5317dc4f34a948fc4266ad56d1eb61" => :sierra
    sha256 "6ccb7fdda21c886d6502425687a29c09378962350c818b4b92b9857d65ff33cd" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/projectcalico/calicoctl"
    dir.install buildpath.children
    cd dir do
      system "glide", "install", "-strip-vendor"
      system "make", "binary"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl --version")
  end
end
