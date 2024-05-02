class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f302d550dfbdc1dcee8fc8858081ae63248421cd3bd0e9d6af60fd6daf1d3345"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfa5bd411a4083c0be3a6a84fa5a7ca710200991aa624bce7daf5d788a40f95a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b054ca1fe80cd227e8109fc6fa04af504e08674275af92ac08b54b56c0b33fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1cddbaf10c6f2bd26659fe58f998cf5c314dc01a7097f1419273fab76fa8d51"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4693d113c8fe33343002028cac06be0e06f2bf81f189ce7995c0dd7ddf894a2"
    sha256 cellar: :any_skip_relocation, ventura:        "df00f6a7116a19af4527e2f1305b05390e71c818ce2d2692c4ee6d4778f4cd2a"
    sha256 cellar: :any_skip_relocation, monterey:       "cb08966fa28fca76b270d10f7b434ae9e680940ad2da8e5c56faaf6a4a3b7a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14c27a24f4382dcd1b08ab372b63259c8635bf0aeddbc368b894fcdd8d58d318"
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
