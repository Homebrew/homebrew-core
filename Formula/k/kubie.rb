class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.21.2.tar.gz"
  sha256 "9756a61c37c102968106b4a915afc96de7fd86621edecfa2bd3b240870e9594d"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "093b87775ab04de9c16b4e5e51ab3baa790e50e4b9a27d532352060e184826fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6b2f9772bc6bda5d05cdf5559feb77500a4910dc2a54a189cc65f0f47d24eb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e14464058a234a913bc0ceda3dc040c33dd220b3efaf556945e2cdf8cddf2da"
    sha256 cellar: :any_skip_relocation, ventura:        "e17f8c93259dfa734c806e973e8cc7e5fb02010872b6a71c798560e20c444189"
    sha256 cellar: :any_skip_relocation, monterey:       "02fb6839a7176b00aa5d8496b853e557a17dc1778ba78b670be73b4df81ba901"
    sha256 cellar: :any_skip_relocation, big_sur:        "01fd64d899ede437d1b364cced06d48913d4f625df2ff45dbfa7f2ea2beb4c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeaddda1dad8a13761372fd5099d82ba3cea6f497ca5c2720e0c61cb656f488c"
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
