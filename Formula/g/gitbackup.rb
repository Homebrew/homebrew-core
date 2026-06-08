class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "697ad5a84e39cc1b444c2129ce6cbcba9a953629486d53d4d87e1b624fc451ae"
  license "MIT"
  head "https://github.com/amitsaha/gitbackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10cd40fec14b449158896a82ded36a16654218713d9fd2842e6dac83cf5d6826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10cd40fec14b449158896a82ded36a16654218713d9fd2842e6dac83cf5d6826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10cd40fec14b449158896a82ded36a16654218713d9fd2842e6dac83cf5d6826"
    sha256 cellar: :any_skip_relocation, sonoma:        "04d0890e0ddf5e10bf1bcf0b92438fb3fd1fd8babc811a8042fb65607a475772"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a3d749c5fa1031d0317f3479665baff492c60b50db388cd68aded2c214c68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1afcb9846e80ec64754ed7ecd89e58d840837d156aff616d870b5d0fa24895"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
