class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "3af0c0c25c7ce1feaa89ea039d400d8c500d035f9a36e86d107d4743392a1da0"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce4f8a80337d624eabeff770bf86b20e8ffb772bbc88b886eb8033c129f6e50c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce4f8a80337d624eabeff770bf86b20e8ffb772bbc88b886eb8033c129f6e50c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce4f8a80337d624eabeff770bf86b20e8ffb772bbc88b886eb8033c129f6e50c"
    sha256 cellar: :any_skip_relocation, sonoma:         "af9ac64d0388cfa78c29319e6cbf4879b0f540842da26973be54f7be9059ecc0"
    sha256 cellar: :any_skip_relocation, ventura:        "af9ac64d0388cfa78c29319e6cbf4879b0f540842da26973be54f7be9059ecc0"
    sha256 cellar: :any_skip_relocation, monterey:       "af9ac64d0388cfa78c29319e6cbf4879b0f540842da26973be54f7be9059ecc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3a5c9b8b7c676e8968367b49d1062191e0f8ba1486e6be14a0fa342ba060ec2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
