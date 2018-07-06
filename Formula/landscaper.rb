class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "v1.0.18",
      :revision => "b063fcef310cf7d5688610ccbfa710cd4eb41a4f"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e124d54f5f5775ccb6fdeb38708d4a5eda94bcc75c3b4d8fb72bb74b8e7f46a5" => :high_sierra
    sha256 "56bd51ee0b2659fd7ececa51d09bd7a16cfc72f2fedb12bcb890c4eccaa9e4e9" => :sierra
    sha256 "457910fab6350bd9155c49d76c9b7d150b9bdd29f8d0191a5a9088ec902a3bbe" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"
      bin.install "build/landscaper"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "This is Landscaper v#{version}", pipe_output("#{bin}/landscaper apply 2>&1")
  end
end
