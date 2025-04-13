class Mox < Formula
  desc "Modern full-featured open source secure mail server"
  homepage "https://www.xmox.nl"
  url "https://github.com/mjl-/mox/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "77d6424e6b4cdafdb5a19ea79adeef982c426c58804671a6a0167edda883d50c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f267981e17ec7e001f6c88b2c372e8e6da332a6efb28794ec589e7d480c7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7f267981e17ec7e001f6c88b2c372e8e6da332a6efb28794ec589e7d480c7c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7f267981e17ec7e001f6c88b2c372e8e6da332a6efb28794ec589e7d480c7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b699c3df96a1dca8de7b8d09ca8088cd290af42bc9b2deb09a0d0651b18297e2"
    sha256 cellar: :any_skip_relocation, ventura:       "b699c3df96a1dca8de7b8d09ca8088cd290af42bc9b2deb09a0d0651b18297e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2d9848f3d8ce296861407977a374744c8260c484b4498e4dd0ce9c08046c8b"
  end

  depends_on "go" => :build

  # Allow setting the version during buildtime
  patch do
    url "https://raw.githubusercontent.com/NixOS/nixpkgs/1ac75001649e3822e9caffaad85d7f1db76e9482/pkgs/by-name/mo/mox/version.patch"
    sha256 "5c35e348e27a235fad80f6a8f68c89fb37d95c9152360619795f2fdd5dc7403f"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/mjl-/mox/moxvar.Version=#{version}
      -X github.com/mjl-/mox/moxvar.VersionBare=#{version}
      -X main.changelogURL=none
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    user = ENV["USER"]
    system bin/"mox", "quickstart", "-skipdial", "email@example.com", user
    assert_path_exists testpath/"config"
    assert_path_exists testpath/"config/mox.conf"

    assert_match "config OK", shell_output("#{bin}/mox config test")

    assert_match version.to_s, shell_output("#{bin}/mox version")
  end
end
