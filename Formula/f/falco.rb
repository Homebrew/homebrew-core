class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "0aa2f046ad1c10aedb0e81b46aabd354d22f161138eb231ee0a11e4b5156c932"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c33b5e090f264f853a74c29717eb053a04af6247fac4ecefcf8a8cda1c44e372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c33b5e090f264f853a74c29717eb053a04af6247fac4ecefcf8a8cda1c44e372"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c33b5e090f264f853a74c29717eb053a04af6247fac4ecefcf8a8cda1c44e372"
    sha256 cellar: :any_skip_relocation, sonoma:        "3014e45ab054195a58d75905cea4bdbde9c88bfc8283fec064644200745fbdaa"
    sha256 cellar: :any_skip_relocation, ventura:       "3014e45ab054195a58d75905cea4bdbde9c88bfc8283fec064644200745fbdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce072d832aecd7147b9f311746d807a727e104129a29efb2b3c0db93903bc61"
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
