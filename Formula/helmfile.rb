class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.99.0.tar.gz"
  sha256 "0c490cdd252180d401577c70074886644a4cdcf93abea3dcd878dc7819605cb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "1933a26433da94dd7edc2853730fcc7a274d0d7c893150adc2829d76cbc29c22" => :catalina
    sha256 "7a7225b2d255a66bb37175e38434c703ca83297c6f8fb654fb936276bd15f334" => :mojave
    sha256 "cab7b82736773ef7dd39857c50934a0762b9bb15f10c276afaa48fe5c93c0669" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
