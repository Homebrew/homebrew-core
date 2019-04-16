class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.54.2.tar.gz"
  sha256 "ea5c861e6d9f2b2bd4d1c5537d86cc0d9456c003ad2dcae9fd846c9283bcbc2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "42f01b9b78a8d434fb2e3a2f9602509327fdd453736258c4d74545ea025819cb" => :mojave
    sha256 "04aaae5317626b72ee92e4aac036a41e8da94fefde9f05703219ce65906b7fa2" => :high_sierra
    sha256 "6d57308a0878019e624bd262b4580871a07821482712f8b05cf6ba97ed97eab1" => :sierra
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
    output = '"stable" has been added to your repositories'
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos")
  end
end
