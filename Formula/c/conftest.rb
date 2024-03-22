class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "7de35c59a28d72cf88985eb684011d80c6084a3cde5e3619a2aa00510f221e86"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13429d91a83f4d120a2dd6e2c865058d1fec14db288b197e2f20a6a4bea0b390"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc5e15dcb428f81c20efc8787911f4357ccd796f94501717b7b3143fba0f627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11b4916db2d67d1992fa6b4997464f8589126d41e54981969b6780faf7857f8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3405a0c6aaa6575b53ea8ca5a40f56bf4d09bcf64a9e9a2efc1495492d2f34c8"
    sha256 cellar: :any_skip_relocation, ventura:        "7de5f3e8efd444b619bf3f82b7e300d734f080accd279fd447cc1704604b3498"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ca5ff1531e3bce1408ee6892881827a3fa8d4335653f1859ec736f82d45bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e80e6d952ff0dcbd548f3ae94ef858ce3cd8caa171665fa8e1094e98a3a5122"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
