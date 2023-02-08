class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.39.0.tar.gz"
  sha256 "b156acfc2f1a8d46aac9fb8c5c6317836f7425f1934f6cdaf9eccc5518598319"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "462f86e55d8b99d7f8d26328b8dff29a243feb34f02dc1b7504a781d99f63c25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337b7c1f810797e65abe8c417a6d8d765953d29fd3bb7626c16775038fca0435"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "067b3ffbe179b556fff1d12f5931b1f5fb964ff8cdaafc680911acd014304f89"
    sha256 cellar: :any_skip_relocation, ventura:        "0664aea514d22473c4d328dfb8dec5b658958ca12820ad8d9c841aa829aad50e"
    sha256 cellar: :any_skip_relocation, monterey:       "199c6ed95bdfa7c15fd96d37b66087dc1c006d91191eac4710b8c0b34387ea38"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdd0b2dc903e33b0d5c99dc8467626ca8e29d40840c04163d57a9b8671811f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c06ed6a178b932748b04a5be282cc5cf4c4b147b5c6166a6e7dfe14e938701"
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
