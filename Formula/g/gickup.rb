class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.47.tar.gz"
  sha256 "ad7ef9de7c55e6f3822326120cb7a823a69bb966489c105bfc4e2ece673a412c"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8eb8ce97c50b7ee7898f35234b5dfea5042529ae711425dfb92dc459eb2ff54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efefe64e404230efef24cae1af7501c5b67d5dc246c4a231cf520f2a1475cf7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be54f5ec6a3ce32f0cb386138b45914485f980a9d60ce1b43052d9185f8b5798"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ec047a302cbce63f015890663d50dec008e5253cf9f70b38c836137e2ef1b30"
    sha256 cellar: :any,                 x86_64_linux:      "9cd348c47e72cbec234977bbb0b21e3683ddb0cf214c56b9f76d8177ba959ddc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    (testpath/"conf.yml").write <<~YAML
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    YAML

    output = shell_output("#{bin}/gickup --dryrun 2>&1", 1)
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
