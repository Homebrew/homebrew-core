class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d0c8d173bfd58abf1d8a3b846d830ddd0bf3e7c6dc22f1b347f4047876727819"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b4b761e90bea10ce45df643c3b9edc205433cc01421de9cdd84c94650f3299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3b4b761e90bea10ce45df643c3b9edc205433cc01421de9cdd84c94650f3299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3b4b761e90bea10ce45df643c3b9edc205433cc01421de9cdd84c94650f3299"
    sha256 cellar: :any_skip_relocation, sonoma:        "04b22ffc8830f8b52d961af32efef67d3128d5cf435f1efe54949bcf0608606a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b173d58b6734d391e4f188fdbf9f1127ddb6ffc5fafb10ce6e13a165a072299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17791e71c71e2172b1a0e15ad666ae83956d8cfda81f040d94044c20d1a51776"
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
