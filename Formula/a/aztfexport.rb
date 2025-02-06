class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.16.0",
      revision: "ec548e436a5229db4121e165eae0c3e4ac9e153b"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67c91a2255003dc1c3a8bf9ab140402eb5f80814fb26f7b0a33753cd1040307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67c91a2255003dc1c3a8bf9ab140402eb5f80814fb26f7b0a33753cd1040307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c67c91a2255003dc1c3a8bf9ab140402eb5f80814fb26f7b0a33753cd1040307"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e2cb0d3ad411bb655e9a954cbfb9a907540f70272476a72f4bf7284d674887"
    sha256 cellar: :any_skip_relocation, ventura:       "d8e2cb0d3ad411bb655e9a954cbfb9a907540f70272476a72f4bf7284d674887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28e7c27f5c43bca47a0d39e5df2288d3004575c1dc01130bfd1ad340e9a222b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}/aztfexport -v")
    assert_match version.to_s, version_output

    mkdir "test" do
      no_resource_group_specified_output = shell_output("#{bin}/aztfexport rg 2>&1", 1)
      assert_match("Error: retrieving subscription id from CLI", no_resource_group_specified_output)
    end
  end
end
