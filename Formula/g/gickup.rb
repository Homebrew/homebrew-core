class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.38.tar.gz"
  sha256 "71df829338c8b6e7b2adb57f0734e67b9c97fb20d32c8193394aad17e64d55bf"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7cb9aa03551d4e440e8baa0418a5f7842b98c6b5ec17454cf5a266f5dca3739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c7e005941f41bfd3ad81c3c664f25c7caa8d18c73512b8d759021821bbea17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3d6dc3c79c773ad733b24264208975a3afc9170ca3f754e56efd829a6526cae"
    sha256 cellar: :any_skip_relocation, sonoma:        "15fee35c0f4420069696061dde479220f4a256b7dfa5490d72114068f6678043"
    sha256 cellar: :any_skip_relocation, ventura:       "ebc3d09294a5e5d4954dce5bd9e60deefbe580eacff2d275f7833fdbfb67f9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400048b77e2a3e715761a9b3d233d235344b188d3d577970cf6516c1570afccc"
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
