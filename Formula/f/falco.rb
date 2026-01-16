class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "9f58c701ed27a30585ea85100c651e0a7c824da32a71d3f34cc9e42240c63e6a"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa56e8cf86a1a65bf5f97016cb35f3d482d546aabfa2858c0aa1841aa99445a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa56e8cf86a1a65bf5f97016cb35f3d482d546aabfa2858c0aa1841aa99445a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa56e8cf86a1a65bf5f97016cb35f3d482d546aabfa2858c0aa1841aa99445a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "abaeef9ec5555df7edd75fc9d93a52564d33de68793ab3ce057a35c2d7db0ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8f7291bf7a25ce19f285c611b16d5eede6aeb81a58b9dd0bac6a228478b3f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f8e7daf73c9f0cf322278326d4299d09e9623a500ad483fce903f2e83476d0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1")

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
