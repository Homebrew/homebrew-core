class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.13.1",
    :revision => "d4731fbe63312934cf7caa6b07acfca6fd2d03c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b310240ebc52af7ef83564c34a7ed27c57af18f2028e33580f2da785039f577" => :catalina
    sha256 "257189119be69358db662c8d2e7d8ab9f523c636f2dfd7ad55e5441974c89250" => :mojave
    sha256 "7d41fb22e90b4aabb773af6f5c39ab7ce5351649e547bccce607761daa515b99" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "helm@2"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/Praqma/helmsman"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"helmsman"
      bin.env_script_all_files(libexec/"bin", :PATH => "#{Formula["helm@2"].opt_bin}:$PATH")
      prefix.install_metafiles
      pkgshare.install "example.yaml"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
