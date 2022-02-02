class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.3.tar.gz"
  sha256 "3f40f82b325910b713b8a325a7483f55211e9ddebe6996422a3c38cf5eeb80a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eba975225125401c4f51e86962249ec49cce0ef26d136fa3c7656a7dc5261ec9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fb7ba27f9e9244346b55357a17a0c918823bb8138d11d46a6515ce335f6d1b8"
    sha256 cellar: :any_skip_relocation, monterey:       "cfe7c61a65c14c7b3e6048d9b52736a65c07f64cbb4ec03a68fa5e3668ad2a3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdd7ca2175d91116f63de3676f70cbd5f2399c8e6de36beab535968c86aa9523"
    sha256 cellar: :any_skip_relocation, catalina:       "af2e585bc772938eb6a374f0dc8e1cac856507ee7435e19c24d7f1517aa1a811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec28211e6aee19bdd4599f42dc795d15071527d3cbdb1a6156fbd4249ad0a407"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
