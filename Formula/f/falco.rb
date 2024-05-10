class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "d4d66edb409bb54b9e4caf491ac7b95595e2a224552b56ddd193d866637f11e0"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa53a836f9c8e2f42853e6b82c3edad6c4c10635867ecdb9d64ba1686674f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ebc830e5b00dc728fe7600fc260308474595c6dad72f195c5156e782eac9b38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71804eb9603daf93dec4bfe0b1aa2bbc56402e3604fc1bb5d8b92305409b6adf"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa0d720e36396f8d8203d8804b3eff2b9ba83c62fae03104b3a42d1692a28bb6"
    sha256 cellar: :any_skip_relocation, ventura:        "daaf71d83f2fff8ba959fad70f2b1f0c421051f9756fef9b132b7b9bad990140"
    sha256 cellar: :any_skip_relocation, monterey:       "7ad9e13ef7bfe62a9485f850eb3b42cdf06b49945cfb402a75c9c7e53dde9c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "162c021fb645d9a16d69129c6650742f9a8ef8735a4e8d4fab4efb574dcc20d3"
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
      #Fastly recv
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
