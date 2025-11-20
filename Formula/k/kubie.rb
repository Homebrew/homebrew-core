class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "b4f9d92f69714a700deb79eb20c657a0d6fe1fb7bc6f205e9affe739c73e4961"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd9aa6225ef208417c4d9867ed38d81cd189d0e739da20c5305a0cf7787cedce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c872c974d46d16a8d6a41802d894c88be5fe4f59c52ffa9a1a95373df1d7339f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db467a89497d12da33a611257c5749458d0398c743b28f2f3809ae6bd036105"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a1a68756304aff50f2f666b166134fa618013af6f0a6470a859c27a265d8aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae57011a7c49d1d16c32c03c61c60048d8f2fd58792372cf80eb4e56041909ea"
    sha256 cellar: :any_skip_relocation, ventura:       "741846d73f310b1d908fd3d6e680e9239edc85127f0817ed3f6f7492804714a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d347a095cf1ec3032cccef7ab2cf569313de304251baabde718149574da50413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98f446724e88c2c943db3a97c9e3b3886a3e86a4cbf35344bb9744451d13a90f"
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
