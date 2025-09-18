class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "b777afab1f54f24708c94a3998f35b4bef5ae77cab6029e1cc752de8e25f340d"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d02431089467de016a4b2c0bc0be7c0a01bff24055add9566fe0002309ed1aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf98ccb1339baedc70ab107d8432d46517889e484ea3e38851e308f0df2edd8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf98ccb1339baedc70ab107d8432d46517889e484ea3e38851e308f0df2edd8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf98ccb1339baedc70ab107d8432d46517889e484ea3e38851e308f0df2edd8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "179552c34c2bebfb129b2dcb8eaadb7e9b138f74ad221b9b1176f0c2e5fac463"
    sha256 cellar: :any_skip_relocation, ventura:       "179552c34c2bebfb129b2dcb8eaadb7e9b138f74ad221b9b1176f0c2e5fac463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ea0885c5a0cf5029571c5369ae7be40c9e852325fee688b276587b03098540b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c446efef7b486def682271fb073101a85e3d093e118948b717fa7e2839bc78a3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
