class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/39.1.0.tar.gz"
  sha256 "bfd6e3acdd5ef31ff214df1ba5b24a3cfc99227e3b149b79cafe5732f191a26f"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f1d48477373e40e38a38f931a13ca7627da1036179b954c379bcd6d1937642e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1d48477373e40e38a38f931a13ca7627da1036179b954c379bcd6d1937642e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1d48477373e40e38a38f931a13ca7627da1036179b954c379bcd6d1937642e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f1d48477373e40e38a38f931a13ca7627da1036179b954c379bcd6d1937642e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c881516167b1e75c141ed5b44640a58b488b315cf615f70660c5be63d7d75e5a"
    sha256 cellar: :any_skip_relocation, ventura:       "c881516167b1e75c141ed5b44640a58b488b315cf615f70660c5be63d7d75e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7bf9d4cc5dd78c301dc2ab96c6bbe1721169256282ef4910848151e5055684"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
