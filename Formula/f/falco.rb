class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "be0e9eb5fa40900a2fd742baffef681a4ff2b26df87b56a61e7f7afc1baaa643"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900a452fc0bcb6a7614417e094129fefaceab48b6293289890327def6ffe8e6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900a452fc0bcb6a7614417e094129fefaceab48b6293289890327def6ffe8e6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "900a452fc0bcb6a7614417e094129fefaceab48b6293289890327def6ffe8e6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "10de0399255dbbfe714eb0c830a23e5cff19ee350760c810ccd7216127679768"
    sha256 cellar: :any_skip_relocation, ventura:       "10de0399255dbbfe714eb0c830a23e5cff19ee350760c810ccd7216127679768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3865fef93fa268facb5572cf09dcc284272a46d3080bf86d08773c5edf6940"
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
