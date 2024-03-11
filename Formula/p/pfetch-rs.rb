class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "6d8ffcad261bfed71070dd5bae6c12458b33ffa4a9245ce702e3a6f7772dde8e"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "382743442401fa332a234ffd46cab82b548cb3c12115e721e6fb3dcd6ff574d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcb9d4fc8e61255088d231495012487be2e110ad0ef98cbe9f7393e27a522cfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65088e433455587cfe20aa0af9082d3620e69cb3bd947d23684b53baedad5427"
    sha256 cellar: :any_skip_relocation, sonoma:         "2923e2da3887f50ef7170d305762022c09418771860dd488c9a43ccf185be524"
    sha256 cellar: :any_skip_relocation, ventura:        "b452cb6b46f52c65493063ddfc6fb0c2ce1982e534469a3c8cc9c534f0a5e2c5"
    sha256 cellar: :any_skip_relocation, monterey:       "8bed5293d068b1d8dff991c53e72b1aa9fc9f6e2021fd12f10650a53d5cf4b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e5649af25a3beadcc107f5f55d9e41cfa8f960dbdacf236bc0027c69817b91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
