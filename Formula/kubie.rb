class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.12.0.tar.gz"
  sha256 "a88f07c49cf3a0683564117684aa28240e4749cc1d81d366d7076d4ffccfba30"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "354930a57e38874a9642179711b2adb3579d5efb0abddf9703ee00ef6dc8980b" => :big_sur
    sha256 "d405cf8c7345fdfdac5fe31773a66c0102adac7b9e86d9f0011cbae48e8b0f9f" => :catalina
    sha256 "f32943f40d0473be59df67805040039368942f56525a0f6071b4a8ce818b2f4a" => :mojave
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
