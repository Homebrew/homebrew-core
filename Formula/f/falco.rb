class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "9c849f412a4b6a8b8052cdc96203139cbbba04bd315af10c9b1a6f42a4bda5c0"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b39c79e557dbd9e91d64947c3437224baceb1daadfea17a7474c9d7d128e8412"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b61869eb07e34b753c98bbdee6e0db722dcaa3688b9eee7e3a52029aaf5776f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9f9e76ed7d1551e88205de938e2fb4d55d044a8b0a7fb4f4dc0b1e45659836"
    sha256 cellar: :any_skip_relocation, sonoma:         "0451011f303136ef4bca729b9357ee5128c3cf6deb8c5120dc80d4b0929700ca"
    sha256 cellar: :any_skip_relocation, ventura:        "398e1199f07c7badcd8ea1ef77bc6a77f3e7ebd6650bb553f3e1134f6586c7fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4e60e084a1c033c940de21c0821056e2b06273f86f176a0ed993a149660bcb5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b89c3c17d575ae79300daa0acf0639a878c533ddb7a331193691e56ed9b0c00d"
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
