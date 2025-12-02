class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.39.tar.gz"
  sha256 "c8cf27a031117c648bc1b40a4b0908e4ab84646d64e6f347c930b5dbe44b68eb"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7532db70eafb1ca1ab00d9260999b11a3c10726d1ebdec3b0bd4996c9909595"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae609f3ef78c9a069f88a83ca6b5b906ec06868e4dddbf9e7c5c0cea1012bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0609476fc46af67b5463990b264bf4b99ae6e379f7a589492c2dff03225e9879"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "010143246859c06f678119c8afdc2b1b848afd290a607e3dfb5e2716da7aedbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc7fc82b842276e632e1482d29c57768d959d1f5961c9aa8851addd698fafd5c"
    sha256 cellar: :any_skip_relocation, ventura:       "4b7a74b4ec817c45f921b3531c43a27e86ce2c021a8d9af52ee6c46c06132083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a697edea33fd125adfc77e7f63d9b3acd228876cb55db1192d11702127eb1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b00e25d59053339e6f46f22b20063ef17516153d09d0cf5dd62a5bfe79724d5a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
