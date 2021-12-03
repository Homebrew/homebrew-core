class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.15.3.tar.gz"
  sha256 "6cf49fdd3ebfe33d654d72f6e0d0697b516208eac4dd42865258798b4f3e83ae"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cda453288df58a5bc11fe552dea2cfbbf950abbe05ba7eb3f829b0c73117225c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa3bd4e86935ea45dcc1e348dafa6a10bdbb9ac7bcc61ca9965d06d555997d72"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5b1fc811cffed920f9f194fe6d14491f36c531e5f67762e11152b159d1bdd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "660eb9cf0cbf36bd069135996bee6d80667819693f46efcf5eaedd921b51eac3"
    sha256 cellar: :any_skip_relocation, catalina:       "5b0fc9ab64b816453c31c5e3e17fa27fc5d75f5e37afd12bc17026c6efaef02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57174305900c2b7410b6d802e0467983cacc56a6df4aa2d9601a1025e34bf8da"
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
