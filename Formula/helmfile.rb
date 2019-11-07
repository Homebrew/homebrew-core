class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.90.8.tar.gz"
  sha256 "e54abf082b2387cd62c4f19423c02efa40820752e9da3ece573de42d2af1fb7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6f2bc03791d2b5594908ce55913d770f72b1af5491cd94c159bad2bc292382b" => :catalina
    sha256 "a92df6389d3784b41a7e862ee4fc7a99c95c542de50c1053adedfa0960d9d75a" => :mojave
    sha256 "bca9a6d72cf64f876108936b7546595e14f4a973389b50f67605cd8c68e5fb16" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/roboll/helmfile").install buildpath.children
    cd "src/github.com/roboll/helmfile" do
      system "go", "build", "-ldflags", "-X main.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["kubernetes-helm"].opt_bin/"helm", "init", "--client-only"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
