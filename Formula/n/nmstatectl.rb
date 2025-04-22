class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.44/nmstate-2.2.44.tar.gz"
  sha256 "2a5645786befd5155192ba4f8ce5d3d91964ddb78d8c0c144cc8ca94bc45255d"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ba3b3a37f3f629d0d854770ff2b634e54e7319b78eb8f7800babcf8eadafbf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddca9ff5f3f699c7dd69e4710ee9f906e75d66755590e1fc3515c997a326cef8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec57761b440a7becc1b472223a5f1d7bf1b864e2ecc3b206bbb7bedd0b66b5db"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf45fb2a6d14f9d71404597d8ec320e28d8bed4461c8b233d020ac7e6277fdb"
    sha256 cellar: :any_skip_relocation, ventura:       "dcb801697950fe4753a4f6b2b816548c2261b6f75d9295240cb78760e0e2dd90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcbd142adc478e2b2ed84af39691e83133f0fb9c2fb4e59147f131bc58ffbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb23e47da25e472c357a0ea1fd20b1d47c8d575bd6880d80ce4273ef4dd6a3cf"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
