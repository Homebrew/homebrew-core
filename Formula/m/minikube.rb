class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.33.1",
      revision: "5883c09216182566a63dff4c326a6fc9ed2982ff"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9489e54e93bfe251c56b7b476a53565793e0bba25d9c65dbedce259144059d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa30d405fa03d050c0193ec09437a5dd8811d82e8f5729044a45c2d93bd5a168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e3b136d7a51ea2f698fcfa2114e5b431bfb5a7641035dc4932a4c4338872e5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "59f0c5d4e1e9b5db0e4bad1b633adaf7b3d7e1a5084317f9bc1eddb74e754fdd"
    sha256 cellar: :any_skip_relocation, ventura:        "d0049a9e1d2a1ce8d1598a78f40aa012439ddc15b4bfb557fb84468da4695ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "90cab2ec81933a18dbf9dc10d1602295b4640f3ecc5ef3a3497c0ca414623065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5598f962e772b41a19c95d533708b09e872dd69a35fcd39efda458ff9e44c326"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", "completion")
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
