class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.79.1.tar.gz"
  sha256 "93fbd9bab028e647b5664708923357571867862b9ab09b3bc730ac3bed14f749"

  bottle do
    cellar :any_skip_relocation
    sha256 "769422fb1bf29bfa2113db32a2eaf7239266392e3289977f5c6d53002b957613" => :mojave
    sha256 "e86a1cd56475dc27ab35fe46c346619cd5c567ae06620a4e6560026e3fd018ef" => :high_sierra
    sha256 "98444367e47bb8a8b2be682702f33def705631a2aefb6fab32d8b893faefa7da" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
