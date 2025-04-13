class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "1ee047be3970368d992304cecc773a3a47068b8eb66365fb7d0c2d7aff91216b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c517a65f23727a7e3781ac711a1e343ee579a68fea06cbbf0efe4ac7873fb75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8def6c63a0ad5dcbd5a6b5b298783d1a50dc29f105310d45c882d245146775ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3572b8a232363769d304e1526541af63fda59a777095cb556e13927273b3330c"
    sha256 cellar: :any_skip_relocation, sonoma:        "49190afffeae49cc9e40f6efb9561a8d28088c4799a405c9b68759b187f84278"
    sha256 cellar: :any_skip_relocation, ventura:       "7b6d96fa97826466a91af5ecdb628b8752f96cad382e656c9b24f6e9a7e65699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd271f01f04ef04f635d0b1ce4279d97fc91ef93bf9ae0bcae848d0820339153"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
