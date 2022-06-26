class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.28.0.tar.gz"
  sha256 "6bfc60ff105b0ea2839f574bc84e9f66d5886c2a7769c359686b01a49818651f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5891e596b518ba7ac2f69f52334614fa31153c1cab7942e2dc26547937e623ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d89f8febacb84effce5fdd331d3536b5a3a78473a0d431d30b0d7cb240091a3e"
    sha256 cellar: :any_skip_relocation, monterey:       "b120936654930e272cdc50cd067f839d2b096b19171d996bccbaa6467a62b54f"
    sha256 cellar: :any_skip_relocation, big_sur:        "718ff4efa76cf607ab0244732d6b4a8b06b0a8b738a81934e7d4df4435a28fe8"
    sha256 cellar: :any_skip_relocation, catalina:       "921b797168fe9dd04ffc326beab7125702b4656afdd02c861da72cc2ea1a2076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09e9c4d8e7a59a1f98a5eda4c7a1c85f4df2e58ec064d71f04e2023aa229435"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
