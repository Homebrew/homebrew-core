class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.13.2.tar.gz"
  sha256 "b8ebf9d70a468e832e9d6a8bb9dedcff3933bf2626903ce7d586f6a9120cff54"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b6477c37aa2de3a9b9a07e78a024eab9b7aacad7444afef3f01b545e65434ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b31f56b71c5298a4ae0a5f733a70e9feea5f7bea4661000dabd09d0f8d0ca75"
    sha256 cellar: :any_skip_relocation, catalina:      "527623fda0a5ab5b705088dda7b30df78f83ae9377e7a3a547d9135e7849475a"
    sha256 cellar: :any_skip_relocation, mojave:        "6a935150ca688ee4fbfdf8be5b5f2984fb1772addacf7e9ee6cf5f11c4bb81c2"
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
