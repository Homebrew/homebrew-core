class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.24.1.tar.gz"
  sha256 "cf1bef8b5a44298d724753ee2f0ba443375b3e3b1572c1c7fff8c5775b803e86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77b7fd1b07b65821563de3879282233472c850071b5cccb503495181edc46c5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc7b9d9c5cd68eac0eb9602be6856505dfb0511b1f98a1e5fa7e99e419e7c75b"
    sha256 cellar: :any_skip_relocation, catalina:      "8412e1a81912ca4d719fdfb57b3ee15ca67db2f3f97cf8a9e5510c66f36b6f08"
    sha256 cellar: :any_skip_relocation, mojave:        "9352809253843cb8520e62b4c683489df0b884debfcba534980c8d50549c0c24"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
