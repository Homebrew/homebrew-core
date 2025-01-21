class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "ccf6bbe16e80c73cf9d17b50342cfc31886e5a8cc6b35bc794dd12ac4a781257"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1b16ccfe63c6ed61c72afa127f78445edddcacd54bfc94886b7749168e38feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac8838d9439d8092f3abb50c030d22f29758f3d646b6ae4cd0deeeba1526ac2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "800c0c924f626a558b70b3900e7c33046e1a725470484a195dda79420cf6cc7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6970d8a6195102b16fad9138908a66b777e8f912dad2b5ba8880425e2bf628e9"
    sha256 cellar: :any_skip_relocation, ventura:       "f96de1a443a0314810b5c5b7a932a493a01d17f69c806b3c6f33f085b553e33e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5fbc19c1a0169f83fad9f030261c6ae9db4873df862358b80ec3ce2e4c912e"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash" => "kubie"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~YAML
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
    YAML

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
