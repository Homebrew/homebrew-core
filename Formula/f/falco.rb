class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "2e30a930d26284a4cdfd1b27b5ef3eb4ef0451fea0d0c4065312ada217d53332"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cf8c285491831399db4fff01be149f3b249a55191b46052f7a65d168a27b6a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cf8c285491831399db4fff01be149f3b249a55191b46052f7a65d168a27b6a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cf8c285491831399db4fff01be149f3b249a55191b46052f7a65d168a27b6a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97bb6310301b3a8a6c6f0aac25faf370a0adcdb13a304d47730cb9f2bba3501"
    sha256 cellar: :any_skip_relocation, ventura:       "d97bb6310301b3a8a6c6f0aac25faf370a0adcdb13a304d47730cb9f2bba3501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "673dc71e66e63edccc4e4aaf3fc6ad544a9305867f404205dfedacfe1b59fc02"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1", 1)

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
