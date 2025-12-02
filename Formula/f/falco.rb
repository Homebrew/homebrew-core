class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "8f339a4cc9a962d087f12ddbcb1de86fd9fc7bbeac00021dd7699f5a7e548eb2"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e199b39efe61166c86f270bbc9792dcc40f46480cd74a5c3404d9f064016d40e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e199b39efe61166c86f270bbc9792dcc40f46480cd74a5c3404d9f064016d40e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e199b39efe61166c86f270bbc9792dcc40f46480cd74a5c3404d9f064016d40e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33eccd5d7f079d1ebbe1a797a972562ef4d9de09c73c8ded5e84829e642c0e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69479066c5a6fae4793acb0807ae53396a4d44ce8be5f17d0f0039b107e0bf63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1c1534a4d1a76edf1226e28b792385a99ab7b282310369a3405a70288078c4"
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
