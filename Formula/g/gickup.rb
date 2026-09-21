class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.47.tar.gz"
  sha256 "ad7ef9de7c55e6f3822326120cb7a823a69bb966489c105bfc4e2ece673a412c"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26533b07a5f0731f1a9542fc9ea6489862702fb78d494c57d79718f215075f5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a26b5ebbc8e5fd22d8df790621d088e441459e97bf4a0c2559e9fad4369158f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4f225e258233adcd7ad10a9a1d3843a5e4aa1d7770303e2e43aef2cc345669b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b69368a81a54a72a51d999220e5270d529f7b7d2b2932c67956aef23cac2948"
    sha256 cellar: :any,                 x86_64_linux:      "23eec013ca1b789639483466ba17217a2912ce776ef8a024d50f651a9c974b01"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
