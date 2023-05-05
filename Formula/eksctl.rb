class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.140.0",
      revision: "94e5eaaba20ca38fc4dbea7f736a892eef48c4cd"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "803f21a568087a9a13a095d274678dd5eba9ceb6033e3e40eb18943be16e7c08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c6ca1961eed22194357065425660190192278c65d6bdf82bd22894f0184cab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf61c71a7aed512438088df4ba9276766d5078045cf27f989ed8437d2f797610"
    sha256 cellar: :any_skip_relocation, ventura:        "8e4fca5e279a6bd681527f7e48079489316bda795c046df2d1e7a07b06b24b03"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b864a221436c9844a5c6537b8456998ffe437bb96619289d98e2e888b1dd8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "caaf4417eec05f9c05c54867c1251e8db14df4f7c33eb90f2620d770f77420ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72866b964a814a8b9afd612c281399a773988dc336700896c3ac18225abab7d0"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
