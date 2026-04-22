class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.40.tar.gz"
  sha256 "abffb493e8f253594385fd8721c9b950b09792210de7fc884494e3c8bc2ce6c3"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a13e58ec8876c97ec7f7604020c33977a8d3482147996f1528e46f6ec26c20c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b10c7ae949970263c7ecc0ffb26372636048eb2c83ed85ab8e22ba433e1e8b94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b6fe6e42a940ba46281bdfeab9a30240c57cce7682f9fa5f780f43032bf0ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "fecc8bfe1f5a3e1ff2a801f2e234defce41f01624ab79c7461d67a384593fb8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06c493910ffb0738dfea5db40d8af73db16a716a8d11ab59c8ce76077826d800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f78f2e937f579e4fe523ed8e27a5d25731f6dee7dddcef2da2c3262edeb538"
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
