class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://github.com/charmbracelet/pop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "360db66ff46cf6331b2851f53477b7bf3a49303b0b46aaacff3d6c1027bf3f40"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5e74d2da1df617b4c74212e2a3228da9fd103c65fe8915beeb1d5c38bb8af8a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f942784cbbe4d0e5e24f74f9e4431d8a798d6109c2ea3f483405430ca7279f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfda627b23f5fe1cef94ea1f9932edcd93f8930af29e6ded7161546112e30e60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03eb314794237b4fc005f0d7128d4679dda5415979c7ee28646d8c88f176a696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03eb314794237b4fc005f0d7128d4679dda5415979c7ee28646d8c88f176a696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03eb314794237b4fc005f0d7128d4679dda5415979c7ee28646d8c88f176a696"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d3084e9113707d91e78dad216111b682b2a3d3e69a2113f16bdd1afbf154815"
    sha256 cellar: :any_skip_relocation, ventura:        "4e17cddc694a0d7da02829d8dd7039dad792b31801468cd13beac526a0855d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "4e17cddc694a0d7da02829d8dd7039dad792b31801468cd13beac526a0855d2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e17cddc694a0d7da02829d8dd7039dad792b31801468cd13beac526a0855d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cbff57ed23b8f4906e232d52655f96377bf72b0fee5c38ebad138c2764c977ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be47be0676bdfcf2a246fc6295eb3b454328e35e827455f0c921ab1a723d1be"
  end

  depends_on "go" => :build

  # patch error status code, remove in next release
  patch do
    url "https://github.com/charmbracelet/pop/commit/65b34a366addd90a9d4da32ac8e5d22268ec16bd.patch?full_index=1"
    sha256 "386fda7d26240d5574b7f402595d01497d7c2d3254e6ad9276a8dd02de0513b7"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"pop", "completion")
    (man1/"pop.1").write Utils.safe_popen_read(bin/"pop", "man")
  end

  test do
    assert_match "environment variable is required",
      shell_output("#{bin}/pop --body 'hi' --subject 'Hello'", 1).chomp

    assert_match version.to_s, shell_output("#{bin}/pop --version")
  end
end
