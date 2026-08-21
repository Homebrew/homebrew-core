class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "bf6eee469cdba77fd0751d96e5dfdb0bb0dc439b28986fadc77e1ac2e54426d8"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b45b976f09a13ea18c870a50da21d4d61193ec4553dd87e8bfd5273c0f190b99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606af74995695fbec908f24475e2d1fdf06ba0ee848679e6997b0102ae17bd9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c41a4ef7f999a79b5b8255e9dad26661f3baec3dcb31678f2f9c3afb01b53d09"
    sha256 cellar: :any_skip_relocation, sonoma:        "f769987b67b136c9a58facd19c5ac4ba938431a29c7d1fc513997151e62556ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cee5a42b59de6dd96950c954cad23a33988096dae0d36966df60287ac3f8aae"
    sha256 cellar: :any,                 x86_64_linux:  "36f1267f7f57c71b634d70ba3bb1f8757e01b2bba461b39a617984642dac7e78"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/openconfig/gnmic/pkg/version.Version=#{version}
      -X github.com/openconfig/gnmic/pkg/version.Commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/version.Date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/version.GitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gnmic", "completion")
  end

  test do
    connection_output = shell_output("#{bin}/gnmic -u gnmi -p dummy --skip-verify \
                                     --timeout 1s -a 127.0.0.1:0 capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
