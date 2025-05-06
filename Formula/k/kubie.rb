class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "4d41e441eb006999f91f962b264730ec092a1352b16e45094f703144e855857e"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162563da6d7eda341e64f02a2c8a6bc7990316f5b44d3bd0011baae7f4824bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef35d6d5916a20e7e40049f29f5f482c69931f36601002a77e2d2edb884270ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69a9ea8f4288fe18075f1b1c71815f94554ad168cb9c8ce0dfb639e677234392"
    sha256 cellar: :any_skip_relocation, sonoma:        "32d2c5ec2ce7902d06cf859253fecf9489d779529f32e318d68a15a16a87a7fc"
    sha256 cellar: :any_skip_relocation, ventura:       "ec6940cb0934fc87b51cb10448b84970752589ef6fd06963ffedcba9e4177617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c53608c2b438262b8d14adbc31cb2524e4e5c75e1b8d4e6791ff9405472392c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "988ef522300b19560127b32022aa92d7d27ece39087c747aed21781c22c74812"
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
