class Mox < Formula
  desc "Modern full-featured open source secure mail server"
  homepage "https://www.xmox.nl"
  url "https://github.com/mjl-/mox/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "22f0d7deeaef6e8bae21f98e37ebcff7d18499591638b89eff484eb7fd06ea37"
  license "MIT"
  head "https://github.com/mjl-/mox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f62ca254136ed301088842bd441431f0be5468c5249f8833bbb13ae3aaf8492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f62ca254136ed301088842bd441431f0be5468c5249f8833bbb13ae3aaf8492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f62ca254136ed301088842bd441431f0be5468c5249f8833bbb13ae3aaf8492"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a66604f45756b09db380b98f631faaaf17cbecea41b53152ec5c5f9ef2bb12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf52625e34f2ddae1242f9a66285fd68473963a9bacc3ed65637c4de36f2d351"
    sha256 cellar: :any,                 x86_64_linux:  "515de7fb7748ba442ba86cedca71fb4df66bbb5830961c205203ce33b366288e"
  end

  depends_on "go" => :build

  # Allow setting the version during buildtime
  patch do
    url "https://raw.githubusercontent.com/NixOS/nixpkgs/1ac75001649e3822e9caffaad85d7f1db76e9482/pkgs/by-name/mo/mox/version.patch"
    sha256 "5c35e348e27a235fad80f6a8f68c89fb37d95c9152360619795f2fdd5dc7403f"
    type :unofficial
  end

  def install
    ldflags = %W[
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
