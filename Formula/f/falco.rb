class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7fd4507f1be53e6af84492d205eb976bc1ff6ef66a1fa27ff856a7fd4449edaf"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ad284f9f1700f84f67979d0775d0a48f8e3a8fb4dbcc7ccaa4489c3aa1016c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68c06462735b29dc46d536b8a48fe486004a0673b1650a83d31105ca13a5acf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4889c483ed90f92337f4b3681cb65d5f36122852ef65f250c4e1e860d138804"
    sha256 cellar: :any_skip_relocation, sonoma:         "48ba5fe8a484bfc7ae727fe91ba06a3ef9bb6d13fddb6cad51201b6bda07f7f9"
    sha256 cellar: :any_skip_relocation, ventura:        "4b0616300c0b963cfb27ad4ad05d64b5e78888296bb9a9c63d74b96a869b4d73"
    sha256 cellar: :any_skip_relocation, monterey:       "d61528258f5709e461a7624fb0631d6aac799963349cfe081d311dafce7511e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cea0044d390dd2c3520ae2ee9f8f6e43edeee651ed50b2d9472ac654997cc7f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/falco"
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
