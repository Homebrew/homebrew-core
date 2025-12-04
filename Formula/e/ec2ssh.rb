class Ec2ssh < Formula
  desc "Simplify SSH connections to AWS EC2 instances"
  homepage "https://github.com/ivoronin/ec2ssh"
  url "https://github.com/ivoronin/ec2ssh/archive/refs/tags/2024.04.21.tar.gz"
  sha256 "a8e4523c65772bc2eba19ea2bc2865b3a43b2ffebb9af4b0da0008f83d2aa1e9"
  license "GPL-3.0-only"
  head "https://github.com/ivoronin/ec2ssh.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bin.install_symlink "ec2ssh" => "ec2scp"
    bin.install_symlink "ec2ssh" => "ec2sftp"
    bin.install_symlink "ec2ssh" => "ec2list"
  end

  test do
    assert_match "ec2ssh", shell_output("#{bin}/ec2ssh --help 2>&1", 1)
  end
end
