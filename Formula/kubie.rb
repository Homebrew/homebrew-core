class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.13.4.tar.gz"
  sha256 "e93e50c88d49569892beabad574c4bfa29e5e4c09820281285a39c2abd552649"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fb90fb9c74a84c23eec5f0ae63e708424daedde033cd8d5eb56a194dc4fb73c"
    sha256 cellar: :any_skip_relocation, big_sur:       "022810888739180a44133cdd5fc282919d0fc91e3ed8e1d050acedf93afd6760"
    sha256 cellar: :any_skip_relocation, catalina:      "3bda881f3b8e4997d87afae28479adbf64bea01a503fb0ec0f666b617188a8b9"
    sha256 cellar: :any_skip_relocation, mojave:        "457189a7fcc468f00e212fa136274e218f5d9b082302fcb4ebcc5b5e9452b85c"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
  end

  test do
    mkdir_p testpath/".kube"
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

    assert_match "kubie #{version}", shell_output("#{bin}/kubie --version")

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
