class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.29.tar.gz"
  sha256 "67ed824659375cd8f07122cb6c520142c69b733cef4a294b27a33b3ac1fc10a3"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a9a0402cc5be930b2d3c7e888dbdb9dc51ff2fcfa4b8cbb40b3bfbc162386d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c6fd0686d42b7ef22201b6e592a621f39445b103998afacb1ca99cb6b19ee3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af65614d18e2c8cd1f0786852858cc24f5e3ef4e9d7ffd5c47f198c874c247b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "99a0d594ae70e3fdfa2d15ecd3be5a48fe446a56d8ccd1218b21486187de4410"
    sha256 cellar: :any_skip_relocation, ventura:        "3b2922fe8edab6e2fa42158a34e79d91fefec11a47429e6851cb36c8ca8936ab"
    sha256 cellar: :any_skip_relocation, monterey:       "76ed742c78c94b3a4a0ec78ae47dd869be410284f6c741a9b4c828cc3c1cb9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51cee5cd9d53e343ff117c6019c13fd0cb47f3beeab19669cb00f41e4f106372"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
