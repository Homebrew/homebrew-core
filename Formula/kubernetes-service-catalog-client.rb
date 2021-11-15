class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog/archive/v0.3.1.tar.gz"
  sha256 "5b463be2102b32bd5a5fed5d433ef53da4d1f70bf007b5a4b78eee7024ca52e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f97c30755a23476d27f49f1769354e0d7346ea09a8a8b4e439fd51b4ffd907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bb5425a81eed75134653e42192c83c14bd2758b5a2a9df631691984490e7c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "bd142e975f80184db59e4d0260e0ace6355ef338e8b06a990be63c9667904cca"
    sha256 cellar: :any_skip_relocation, big_sur:        "64f2328460df6ccbfd00e299b61e3770a9419de66f70ada056674259036203b4"
    sha256 cellar: :any_skip_relocation, catalina:       "a6f26e163ee15f601fef1b974e3c55f22a4c7333aea3ddf6ce009f386b58db18"
    sha256 cellar: :any_skip_relocation, mojave:         "9d29ae7fed57216e663459a4964c9946475329bdd4a6aa0666d69019840c6abf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a6b37292f716de1ba860d6e38905aa80063120ca8018d58b0bd05bca7475a253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41818d0040c8d3943167a585393487deef56e651c0308ef50cde5cf0692e3ae"
  end

  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"

    ldflags = %W[
      -s -w
      -X github.com/kubernetes-sigs/service-catalog/pkg.VERSION=v#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-o",
            bin/"svcat", "./cmd/svcat"
    prefix.install_metafiles
  end

  test do
    version_output = shell_output("#{bin}/svcat version --client 2>&1", 1)
    assert_match "Error: could not get Kubernetes config for context", version_output
  end
end
