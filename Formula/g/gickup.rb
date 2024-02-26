class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.27.tar.gz"
  sha256 "6c2e1927fe0c95917508ce6f2dec04db39f12bcef16800a0ad44f9415f63c680"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "801f32d9444529a0e3e442843c826a4c958744523ae10d02e0d589c5b3873a8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59bdea75a80f33cddb3811668ce5e6a22559b0e9adb4a8cfb18ed5e3949e422c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9957c7c12f7fae2c972b6bc050c444910be90733fd539192bc7b7d815f3890cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fcfc5cdd4d6b20a40506803ad66bf2bb34a32f102edcfc003e651cb22f9ff48"
    sha256 cellar: :any_skip_relocation, ventura:        "47f96aba4cfd4b70fe77b3a5e62c2e43a745df7b9cf47698f59ce32ac435c59d"
    sha256 cellar: :any_skip_relocation, monterey:       "25c56413b807fd2a8c317195fb4cb017e611bd91d9586cda8871615cf7063b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53680e4e006ec714b6bbf1109054a010ed09b0990591920b4441cd8b2816aa21"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
