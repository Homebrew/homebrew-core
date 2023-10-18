class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.18.5.tar.gz"
  sha256 "56ea61a477edc25e830ebd1af0cbf8677937bacc537cebbdae588c7d7f22445f"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ccc3052b3ca8a11533650a2069839d07eaafc185a84d8af4dd7c419e9cec154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eafaff6b01b77739ed3ada27cfbbd68c3863dd5fd0dccf9b5f19c4147af303c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "279130eedc84aa1448ce4f536027de2fea82fc0ba8b8c421a3ac0c90010ce2b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5dbf78d66899e7c5201cf037a57fc2f9587ee967dbe8774f06004284f6f9862"
    sha256 cellar: :any_skip_relocation, ventura:        "f87e8cee30b225273d9ea786a7cd3130ce0bbb10f7841323a9f25d5d07b9399f"
    sha256 cellar: :any_skip_relocation, monterey:       "60ae4dfe6a5c422fb5afa2f43d93248c298426af70acf834045aeafee1c4451b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e458365354101b994b3382b81bb51729a1a272036941308500b5ff75f1920751"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
