class Amass < Formula
  desc "In-depth attack surface mapping and asset discovery"
  homepage "https://owasp.org/www-project-amass/"
  url "https://github.com/owasp-amass/amass/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "975b23891423a29767d9d83c4d4d501e5ae524288be424b0052e61a9fe8a2869"
  license "Apache-2.0"
  head "https://github.com/owasp-amass/amass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91cdfd185942688add2d63aec30c4b7fe8828c2fbc8072ab18010aac7e18813e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91cdfd185942688add2d63aec30c4b7fe8828c2fbc8072ab18010aac7e18813e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91cdfd185942688add2d63aec30c4b7fe8828c2fbc8072ab18010aac7e18813e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91cdfd185942688add2d63aec30c4b7fe8828c2fbc8072ab18010aac7e18813e"
    sha256 cellar: :any_skip_relocation, sonoma:        "58786c0989372a5d55673fff78637bbe533a4efac67979e379e666e5b5a98f18"
    sha256 cellar: :any_skip_relocation, ventura:       "58786c0989372a5d55673fff78637bbe533a4efac67979e379e666e5b5a98f18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2d310e25c95898c0c70021e1cd9319d9b8e1cd1aad50d54f2f7f4991547ebb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6fec44a8e37e2acf94f169a8f888551fcfdd33a1d22b4d742204fc02ac85e6"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/owasp-amass/amass/pull/1083
  patch do
    url "https://github.com/owasp-amass/amass/commit/fbdb97b6884e0ac01526c9c555a1e4a37533fa95.patch?full_index=1"
    sha256 "188412fb8e1663bacfd222828974a792a40c3e795dee62133244e27a45772883"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/amass"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amass --version 2>&1")

    (testpath/"config.yaml").write <<~YAML
      scope:
        domains:
          - example.com
    YAML

    system bin/"amass", "enum", "-list", "-config", testpath/"config.yaml"
  end
end
