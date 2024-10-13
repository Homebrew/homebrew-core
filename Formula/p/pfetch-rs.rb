class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "e433ae2cb4dd70b225a19436c668d0bb932b429983d0293563f356677cc7e567"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7a631b3d3ce451c9b2441c411b5f0cd88cca783281b3413aa5e392b1ef525de0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ae1919a5fdd354ca5411453262f76901a2d93ae4e47a037f75a61a66b0cce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e223963c790e1aca11272e120c104aba5a876c34b40e8e26b182fd72a447359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93bb9b25718b3517ae39f15db10eef718e3c2e79b2b9318e6357adc5ce44261"
    sha256 cellar: :any_skip_relocation, sonoma:         "322308c56dbcc26689f16e075dcdee4a7f22a9a393585fe03170945de80148e7"
    sha256 cellar: :any_skip_relocation, ventura:        "d1cca6fccad90d1dcb2227f7de3496114ae163a807e8565b6082901943c0b5d3"
    sha256 cellar: :any_skip_relocation, monterey:       "2079944867c532faa38f2b3a8fe67f2e6e3856a2de29aab57f3eb0823027189b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d797d6617e9174543e201f28118ce2b96e362922c47cf5bb79193f8fef515d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
