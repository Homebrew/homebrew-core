class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://okteto.com"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "63891c5e490fd5bb8f0a4e105e44318cf425ca80844dc07283a6baf965c1aa3b"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco --version 2>&1", 1)

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        return (pass);
      }
    EOS

    assert_match "VCL looks very nice", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "variable \"httpbin_org\" is not defined", shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
