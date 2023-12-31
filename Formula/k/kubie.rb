class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "e6722811998ca497edd365e27d96c7f672221ffb5d7fd59ec9fbf181831b01f8"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "965617907e5ff88fc1125cd9691b592629164f70c797659178f9041bf6cb751b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7c2b8e339bb482ca5537fcd6d3948edbe79af81b0661b1f31b15366387d8c90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2298df126e6a59bce42f100b41391b8e52c478f2b2483266dc3540aaa30457ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5a76d34b6215239a6f5e3f58a29175559e749abd3eddc0601d02aca37ec9c90"
    sha256 cellar: :any_skip_relocation, ventura:        "7dbf95084717dc2170f2e31f93620686c8c60ba4f30fbfd674e354f97fc7c9cc"
    sha256 cellar: :any_skip_relocation, monterey:       "3603a65f75f778367ca3768a5868ea5b5b3d2d23475930af11a125e154c45ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d53d5c698a845ffaf4ab53f92cb3345bfd7f229174e2a8873d5516a7e9a50f68"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    EOS

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
