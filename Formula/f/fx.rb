class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/36.0.3.tar.gz"
  sha256 "1159bc6b556d39843f7e786b06ad8918e4d1a6e64f21539598d3a72dbbc9b1c7"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb640e32c4ba17005e324f08be8b1fed46be610b33b99037b37d27e3b7306b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb640e32c4ba17005e324f08be8b1fed46be610b33b99037b37d27e3b7306b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fb640e32c4ba17005e324f08be8b1fed46be610b33b99037b37d27e3b7306b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1efd63e0351c9ecaecc51809439f62111d1eac470ed44335cb444673110fccf"
    sha256 cellar: :any_skip_relocation, ventura:       "f1efd63e0351c9ecaecc51809439f62111d1eac470ed44335cb444673110fccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6493e00ef4372ea1d73bb3a64b8906e93cc153b32153315c9f75a257a5acd976"
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
